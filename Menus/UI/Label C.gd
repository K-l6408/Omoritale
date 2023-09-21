@tool
extends Label

func _process(_delta):
	if Engine.is_editor_hint():
		text = "%.2f" % ($"../../Bar".size.x/$"../..".size.x)
	else:
		var h = Globals.PlayerStats.HP
		if fmod(h, 1) < 0.01 or fmod(h, 1) > 0.99:
			text = "%.0f" % h
		elif fmod(h * 10, 1) < 0.1 or fmod(h * 10, 1) > 0.9:
			text = "%.1f" % h
		else:
			text = "%.2f" % h
