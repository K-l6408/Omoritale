extends Node2D

func set_layout(layout):
	match layout:
		"QWERTY":
			Globals.KeyboardLayout = "QWERTYUIOP\nASDFGHJKL←\nZXCVBNM-_*"
		"QWERTZ":
			Globals.KeyboardLayout = "QWERTZUIOP\nASDFGHJKL←\nYXCVBNM-_*"
		"ÄWERTY":
			Globals.KeyboardLayout = "ÄWERTYUIOP\nQSDFGHJKL←\nZÜÇÝBNM-_*"
		"AZERTY":
			Globals.KeyboardLayout = "QWERTZUIOP\nASDFGHJKL←\nYXCVBNM-_*"
	get_tree().change_scene_to_file("res://Menus/Hub.tscn")
