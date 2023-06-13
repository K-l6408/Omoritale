extends RichTextLabel

func _process(_delta):
	if Globals.PlayerName != "":
		text = "%-7s" % Globals.PlayerName + "[font_size=25] LV " + str(Globals.LV)
	else:
		text = "[null] [font_size=25] LV " + str(Globals.LV)
