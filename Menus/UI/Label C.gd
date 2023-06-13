@tool
extends Label

func _process(_delta):
	if Engine.is_editor_hint():
		text = "%.2f" % ($"../../Bar".size.x/$"../..".size.x)
	else:
		text = "%d" % ($"../../Bar".size.x/$"../..".size.x*Globals.MHPfromLV(Globals.LV))
