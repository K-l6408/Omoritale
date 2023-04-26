@tool
extends Label

func _process(_delta):
	text = "%d" % round($"../..".size.x/1.2)
