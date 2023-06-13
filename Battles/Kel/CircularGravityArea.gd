@tool
extends Area2D

enum type {
	Clockwise, CounterClockwise, Inside, Outside
}

var textures = [
	preload("res://Assets/Sprites/GravityCircleCW.png"),
	preload("res://Assets/Sprites/GravityCircleCCW.png"),
	preload("res://Assets/Sprites/GravityCircle-In.png"),
	preload("res://Assets/Sprites/GravityCircle-Out.png")
]

@export var Type := type.CounterClockwise

func _physics_process(delta):
	for body in get_overlapping_bodies():
		switch_gravity(body, delta)
	$Sprite2D.texture = textures[Type]

func switch_gravity(body, delta):
	if body is Soul:
		if body.State.Blue:
			match Type:
				type.Clockwise:
					body.rotation = to_local(body.global_position).angle()
				type.CounterClockwise:
					body.rotation = to_local(body.global_position).angle() + PI
				type.Inside:
					body.rotation = to_local(body.global_position).angle() + PI / 2
				type.Outside:
					body.rotation = to_local(body.global_position).angle() - PI / 2
			var j = body.fall.rotated(-body.global_rotation).y
			body.fall = Vector2(0, min(j, 500)).rotated(body.global_rotation)
