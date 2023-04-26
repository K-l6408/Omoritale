@tool
extends Area2D

@export var Polygon : PackedVector2Array

func _physics_process(_delta):
	$CollisionShape2D.polygon = Polygon
	$Polygon2D.polygon = Polygon

func remove_controls(body):
	if body is Soul:
		body.controls = false

func return_controls(body):
	if body is Soul:
		body.controls = true
