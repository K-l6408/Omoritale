extends Label

func _process(_delta):
	if Globals.PlayerName != "":
		text = Globals.PlayerName
	else:
		text = "[null]"
