extends ColorRect

var G = 0

func _ready():
	for j in Globals.Enemies:
		var P = %Person.duplicate()
		P.show()
		P.text = j.Name
		P.set_focus_mode(FOCUS_ALL)
		$Rect/VBoxContainer.add_child(P)
	if $Rect/VBoxContainer.get_child_count() == 0:
		emit_signal("fuck", -1)
	else:
		$Rect/VBoxContainer.get_child(0).grab_focus()

func _process(delta):
	if G < 1:
		$Rect.color = lerp(Color("fff"), Color("93f"), G)
		G += delta
	if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_cancel"):
		emit_signal("fuck", -1)

signal fuck(stat)
