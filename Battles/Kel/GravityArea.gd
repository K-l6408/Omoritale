@tool
extends Area2D

@export var Polygon : PackedVector2Array

func _physics_process(_delta):
	$Polygon2D/Sprite2D.modulate = Color.from_hsv(rotation / TAU + .5, .7, .9 * .75, 1)
	$CollisionShape2D.polygon = Polygon
	$Polygon2D.polygon = Polygon
	for body in get_overlapping_bodies():
		switch_gravity(body)

func switch_gravity(body):
	if body is Soul:
		if body.State.Blue:
			body.rotation = rotation
