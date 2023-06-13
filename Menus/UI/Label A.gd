@tool
extends Label

func _process(_delta):
	text = "%d" % ($"../../Bar".size.x/1.2+.5)
