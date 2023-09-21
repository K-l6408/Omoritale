extends Control

enum BalloonMode {
	RIGHT, LEFT, UP, DOWN
}

@export var mode : BalloonMode

@onready var balloon: NinePatchRect = $Balloon
@onready var dialogue_label := $Balloon/DialogueLabel
@onready var polygon := $Balloon/Polygon2D

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
			return
		
		dialogue_line = next_dialogue_line
		
		dialogue_label.modulate.a = 0
		dialogue_label.custom_minimum_size.x = dialogue_label.get_parent().size.x - 1
		dialogue_label.dialogue_line = dialogue_line
		dialogue_label.modulate.a = 1
		if not dialogue_line.text.is_empty():
			dialogue_label.type_out()
			await dialogue_label.finished_typing
		
		if dialogue_line.time != null:
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
	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)

## Start some dialogue
func start(dialogue_resource: DialogueResource, title: String, extra_game_states: Array = []) -> void:
	temporary_game_states = extra_game_states
	is_waiting_for_input = false
	resource = dialogue_resource
	show()
	
	self.dialogue_line = await resource.get_next_dialogue_line(title, temporary_game_states)


## Go to the next line
func next(next_id: String) -> void:
	self.dialogue_line = await resource.get_next_dialogue_line(next_id, temporary_game_states)

func _on_mutated(_mutation: Dictionary) -> void:
	is_waiting_for_input = false
	await get_tree().create_timer(0.1).timeout


func _on_response_mouse_entered(item: Control) -> void:
	if "Disallowed" in item.name: return
	
	item.grab_focus()

func _on_balloon_gui_input(event: InputEvent) -> void:
	if not is_waiting_for_input: return
	if dialogue_line.responses.size() > 0: return

	# When there are no response options the balloon itself is the clickable thing	
	get_viewport().set_input_as_handled()
	
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		next(dialogue_line.next_id)
	elif event.is_action_pressed("ui_accept") and get_viewport().gui_get_focus_owner() == balloon:
		next(dialogue_line.next_id)

func type(letter, _letter_index, _speed):
	if letter in " \n\t*x":
		return
	var stream = character_audio(dialogue_line.character)
	if stream != "":
		$Audio.stream = load("res://Assets/Audio/Soundbytes/" + stream)
		$Audio.play()
	match mode:
		BalloonMode.RIGHT:
			polygon.position.x = $Balloon.size.x
			polygon.position.y = $Balloon.size.y / 2
			polygon.rotation_degrees = 0
			balloon.position = -Vector2(balloon.size.x / 2 + 40, balloon.size.y / 4)
		BalloonMode.UP:
			polygon.position.x = $Balloon.size.x / 2
			polygon.position.y = $Balloon.size.y
			polygon.rotation_degrees = 90
			balloon.position = -Vector2(balloon.size.x / 4, balloon.size.y / 2 + 40)
		BalloonMode.LEFT:
			polygon.position.x = 0
			polygon.position.y = $Balloon.size.y / 2
			polygon.rotation_degrees = 180
			balloon.position = Vector2(40, -balloon.size.y / 4)
		BalloonMode.DOWN:
			polygon.position.x = $Balloon.size.x / 2
			polygon.position.y = 0
			polygon.rotation_degrees = -90
			balloon.position = Vector2(-balloon.size.x / 4, 40)

func character_audio(chr):
	if has_node(chr):
		var pos = get_node(chr)
		if pos is Marker2D:
			pos.top_level = true
			global_position = pos.global_position
			if is_equal_approx(pos.global_rotation, 0):
				mode = BalloonMode.RIGHT
			if is_equal_approx(pos.global_rotation, PI):
				mode = BalloonMode.LEFT
			if is_equal_approx(pos.global_rotation, PI / 2):
				mode = BalloonMode.UP
			if is_equal_approx(pos.global_rotation, PI / -2):
				mode = BalloonMode.DOWN
	match chr:
		"Mari":
			balloon.self_modulate = Color("cb8bff")
			polygon.self_modulate = Color("cb8bff")
			return "mari.ogg"
		"Melony":
			balloon.self_modulate = Color("d19292")
			polygon.self_modulate = Color("d19292")
			return "mln.wav"
		_:
			balloon.self_modulate = Color.WHITE
			polygon.self_modulate = Color.WHITE
			return "txt.wav"

signal finished()
