extends Node2D

func _ready():
	if Globals.KeyboardLayout == "":
		get_tree().change_scene_to_file("res://Menus/Config.tscn")
	elif Globals.PlayerName == "":
		get_tree().change_scene_to_file("res://Menus/Namer.tscn")

func one():
	Globals.PlayerPosition = Vector2(0, 0)
	var tw = create_tween().set_parallel()
	tw.tween_property($Camera2D, "position", Vector2(60, 130), 2)
	tw.tween_property($Camera2D/ColorRect, "color", Color.WHITE, 2)
	tw.tween_property($Camera2D, "zoom", Vector2(3, 3), 2)
	await tw.finished
	get_tree().change_scene_to_file("res://Battles/Watermelon/Cutscene.tscn")
