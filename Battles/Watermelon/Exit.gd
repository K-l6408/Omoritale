extends Area2D

@onready var PLAYER = %Sunnisk

func _ready():
	if Globals.PlayerPosition == Vector2(0, 0):
		$CollisionPolygon2D.disabled = true

func start_cutscene_eval(body):
	if body == PLAYER:
		get_tree().change_scene_to_file("res://Menus/Hub.tscn")
