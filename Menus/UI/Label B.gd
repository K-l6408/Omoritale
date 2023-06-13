@tool
extends Label

func _process(_delta):
	text = "%d" % ($"../..".size.x/1.2+.5)
