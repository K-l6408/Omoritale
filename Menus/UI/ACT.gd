extends Node2D

var G = 0
var m = 1

func _ready():
	for j in Globals.Enemies:
		var P = $Option.duplicate()
		P.show()
		P.text = j.Name
		P.connect("focus_entered", show_acts.bind(j))
		P.connect("gui_input", _enemy_select)
		P.set_focus_mode(Control.FOCUS_ALL)
		$PPL/Rect/VBoxContainer.add_child(P)
	if $PPL/Rect/VBoxContainer.get_child_count() == 0:
		emit_signal("nvm")
	else:
		var V = $PPL/Rect/VBoxContainer
		V.get_child(0).focus_neighbor_top = V.get_child(V.get_child_count()-1).get_path()
		V.get_child(V.get_child_count()-1).focus_neighbor_bottom = V.get_child(0).get_path()
		V.get_child(0).grab_focus()

func _process(delta):
	if G < 1:
		$PPL/Rect.color = lerp(Color("fff"), Color("93f"), G)
		$ACT/Rect.color = lerp(Color("fff"), Color("93f"), G)
		$PPL.size = lerp(Vector2(450, 200), Vector2(440, 200), G)
		$ACT.size = lerp(Vector2(450, 200), Vector2(440, 200), G)
		$ACT.position = lerp(Vector2(480, 333), Vector2(490, 333), G)
		G += delta * m
	else:
		$PPL/Rect.color = Color("93f")
		$ACT/Rect.color = Color("93f")
		$PPL.size = Vector2(440, 200)
		$ACT.size = Vector2(440, 200)
		$ACT.position = Vector2(490, 333)
		G = 1
	if G < 0:
		emit_signal("done")
		queue_free()

func _enemy_select(event:InputEvent):
	if (event.is_action("ui_accept") or event.is_action("ui_right")) and event.is_pressed():
		if $ACT/Rect/ScrollContainer/VBoxContainer.get_child_count() == 0:
			emit_signal("nvm")
		else:
			await get_tree().process_frame
			$ACT/Rect/ScrollContainer/VBoxContainer.get_child(0).grab_focus()
	if event.is_action("ui_cancel") and event.is_pressed():
		emit_signal("nvm")

func show_acts(enemy:Enemy):
	for k in $ACT/Rect/ScrollContainer/VBoxContainer.get_children(): k.queue_free()
	await get_tree().process_frame
	for i in enemy.ACTs:
		var P = $Option.duplicate()
		P.show()
		P.text = i
		P.connect("gui_input", func(event:InputEvent):
			if event.is_action("ui_accept") and event.is_pressed():
				emit_signal("act", enemy.Name, i)
				m = -1
				if G >= 1: G = 0.99
		)
		P.set_focus_mode(Control.FOCUS_ALL)
		$ACT/Rect/ScrollContainer/VBoxContainer.add_child(P)
	var V = $ACT/Rect/ScrollContainer/VBoxContainer
	V.get_child(0).focus_neighbor_top = V.get_child(V.get_child_count()-1).get_path()
	V.get_child(V.get_child_count()-1).focus_neighbor_bottom = V.get_child(0).get_path()

signal nvm()
signal act(enemy, action)
signal done()
