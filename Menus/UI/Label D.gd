@tool
extends Label

func _process(_delta):
	if Engine.is_editor_hint():
		text = "1.00"
	else:
		text = "%d" % Globals.MHPfromLV(Globals.LV)
