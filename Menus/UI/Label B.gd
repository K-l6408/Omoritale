@tool
extends Label

func _process(_delta):
	var h = ($"../..".size.x/1.2)
	if fmod(h, 1) < 0.01 or fmod(h, 1) > 0.99:
		text = "%.0f" % h
	elif fmod(h * 10, 1) < 0.1 or fmod(h * 10, 1) > 0.9:
		text = "%.1f" % h
	else:
		text = "%.2f" % h
