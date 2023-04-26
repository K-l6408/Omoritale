@tool
extends Label

func _process(_delta):
	text = "%d" % round($"../../Bar".size.x/1.2)
