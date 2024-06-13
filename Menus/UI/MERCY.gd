extends Control

var G = 0
var m = 1

func _ready():
	$Rect/VBoxContainer/Flee.visible = Globals.canflee
	var V = $Rect/VBoxContainer
	for i in V.get_child_count():
		V.get_child(i).connect("gui_input", func(event:InputEvent):
			if event.is_action("ui_accept") and event.is_pressed():
				emit_signal("send", i)
				m = -1
				if G >= 1: G = 0.99
		)
	V.get_child(0).focus_neighbor_top = V.get_child(V.get_child_count()-1).get_path()
	V.get_child(V.get_child_count()-1).focus_neighbor_bottom = V.get_child(0).get_path()
	V.get_child(0).grab_focus()

func _process(delta):
	if G < 1:
		$Rect.color = lerp(Color("fff"), Color("9f3"), G)
		G += delta * m
	else:
		$Rect.color = Color("9f3")
		G = 1
	if G < 0:
		emit_signal("done")
		queue_free()

func _input(event):
	if event.is_action("ui_cancel") and event.is_pressed():
		emit_signal("nvm")

signal nvm()
signal done()
signal send(i)
