extends CanvasLayer

@onready var balloon: ColorRect = $Balloon
@onready var margin: MarginContainer = $Balloon/Margin
@onready var character_label: RichTextLabel = $Balloon/Margin/VBox/CharacterLabel
@onready var dialogue_label := $Balloon/Margin/VBox/DialogueLabel
@onready var responses_menu: HBoxContainer = $Balloon/Margin/VBox/Responses
@onready var response_template: RichTextLabel = %ResponseTemplate

## The dialogue resource
var resource: DialogueResource

## Temporary game states
var temporary_game_states: Array = []

## See if we are waiting for the player
var is_waiting_for_input: bool = false

## The current line
var dialogue_line: DialogueLine:
	set(next_dialogue_line):
		is_waiting_for_input = false
		
		if not next_dialogue_line:
			hide()
			emit_signal("finished")
			return
		
		# Remove any previous responses
		for child in responses_menu.get_children():
			responses_menu.remove_child(child)
			child.queue_free()
		
		dialogue_line = next_dialogue_line
		
		character_label.visible = not dialogue_line.character.is_empty()
		character_label.text = "[right]" + tr(dialogue_line.character, "dialogue")
		
		dialogue_label.modulate.a = 0
		dialogue_label.custom_minimum_size.x = dialogue_label.get_parent().size.x - 1
		dialogue_label.dialogue_line = dialogue_line

		# Show any responses we have
		responses_menu.modulate.a = 0
		if dialogue_line.responses.size() > 0:
			for response in dialogue_line.responses:
				# Duplicate the template so we can grab the fonts, sizing, etc
				var item: RichTextLabel = response_template.duplicate()
				item.name = "Response%d" % responses_menu.get_child_count()
				if not response.is_allowed:
					item.name = String(item.name) + "Disallowed"
					item.modulate.a = 0.4
				item.text = response.text
				item.show()
				responses_menu.add_child(item)
		
		dialogue_label.modulate.a = 1
		if not dialogue_line.text.is_empty():
			dialogue_label.type_out()
			await dialogue_label.finished_typing
		
		# Wait for input
		if dialogue_line.responses.size() > 0:
			responses_menu.modulate.a = 1
			configure_menu()
		elif dialogue_line.time != null:
			var time = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
			await get_tree().create_timer(time).timeout
			next(dialogue_line.next_id)
		else:
			is_waiting_for_input = true
			balloon.focus_mode = Control.FOCUS_ALL
			balloon.grab_focus()
	get:
		return dialogue_line


func _ready() -> void:
	response_template.hide()
	
	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)


## Start some dialogue
func start(dialogue_resource: DialogueResource, title: String, extra_game_states: Array = []) -> void:
	show()
	temporary_game_states = extra_game_states
	is_waiting_for_input = false
	resource = dialogue_resource
	
	self.dialogue_line = await resource.get_next_dialogue_line(title, temporary_game_states)

## Go to the next line
func next(next_id: String) -> void:
	self.dialogue_line = await resource.get_next_dialogue_line(next_id, temporary_game_states)


### Helpers


# Set up keyboard movement and signals for the response menu
func configure_menu() -> void:
	balloon.focus_mode = Control.FOCUS_NONE
	
	var items = get_responses()
	for i in items.size():
		var item: Control = items[i]
		
		item.focus_mode = Control.FOCUS_ALL
		
		item.focus_neighbor_left = item.get_path()
		item.focus_neighbor_right = item.get_path()
		
		if i == 0:
			item.focus_neighbor_left = items.back().get_path()
			item.focus_previous = items.back().get_path()
		else:
			item.focus_neighbor_left = items[i - 1].get_path()
			item.focus_previous = items[i - 1].get_path()
		
		if i == items.size() - 1:
			item.focus_neighbor_right = items[0].get_path()
			item.focus_next = items[0].get_path()
		else:
			item.focus_neighbor_right = items[i + 1].get_path()
			item.focus_next = items[i + 1].get_path()
		
#		item.mouse_entered.connect(_on_response_mouse_entered.bind(item))
		item.gui_input.connect(_on_response_gui_input.bind(item))
	
	items[0].grab_focus()


# Get a list of enabled items
func get_responses() -> Array:
	var items: Array = []
	for child in responses_menu.get_children():
		if "Disallowed" in child.name: continue
		items.append(child)
		
	return items


func handle_resize() -> void:
	if not is_instance_valid(margin):
		call_deferred("handle_resize")
		return


### Signals


func _on_mutated(_mutation: Dictionary) -> void:
	is_waiting_for_input = false
	await get_tree().create_timer(0.1).timeout


func _on_response_mouse_entered(item: Control) -> void:
	if "Disallowed" in item.name: return
	
	item.grab_focus()

func _unhandled_input(_event: InputEvent) -> void:
	# Only the balloon is allowed to handle input while it's showing
	if visible:
		get_viewport().set_input_as_handled()

func _on_response_gui_input(event: InputEvent, item: Control) -> void:
	if "Disallowed" in item.name: return
	
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		next(dialogue_line.responses[item.get_index()].next_id)
	elif event.is_action_pressed("ui_accept") and item in get_responses():
		next(dialogue_line.responses[item.get_index()].next_id)


func _on_balloon_gui_input(event: InputEvent) -> void:
	if not is_waiting_for_input: return
	if dialogue_line.responses.size() > 0: return

	# When there are no response options the balloon itself is the clickable thing	
	get_viewport().set_input_as_handled()
	
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		next(dialogue_line.next_id)
	elif event.is_action_pressed("ui_accept") and get_viewport().gui_get_focus_owner() == balloon:
		next(dialogue_line.next_id)


func _on_margin_resized() -> void:
	handle_resize()

func type(letter, _letter_index, _speed):
	if letter in " \n\t>":
		return
	var stream = character_audio(dialogue_line.character)
	if stream != "":
		$Audio.stream = load("res://Assets/Audio/Soundbytes/" + stream)
		$Audio.play()
	balloon.size.x = DisplayServer.window_get_size().x - 60

func character_audio(chr):
	match chr:
		"Melony":
			$Balloon/Rect.modulate = Color("d19292")
			return "mln.wav"
		_:
			$Balloon/Rect.modulate = Color.WHITE
			return "txt.wav"

signal finished()
