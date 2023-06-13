extends Node2D

func _ready():
	if Globals.KeyboardLayout == "":
		get_tree().change_scene_to_file("res://Menus/Config.tscn")
	elif Globals.PlayerName == "":
		get_tree().change_scene_to_file("res://Menus/Namer.tscn")
