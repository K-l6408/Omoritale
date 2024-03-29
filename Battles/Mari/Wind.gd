@tool
extends Area2D

@export var Size = Vector2i(100, 100)
@export var Strengþ = 1.0

func _process(_delta):
	if Size.x < 0: Size.x = 0
	if Size.y < 0: Size.y = 0
	$CollisionShape2D.shape.size = Size
	$Sprite2D.region_rect.size.x = Size.x
	$Sprite2D.region_rect.size.y = Size.y

func _physics_process(delta):
	$Sprite2D.material.set_shader_parameter("speed", Strengþ)
	for i in get_overlapping_bodies():
		if i is Soul:
			var k = false
			for j in i.get_node("HitBox").get_overlapping_areas():
				if j.get("Shockwave"):
					k = true
					break
			if k: continue
			if i.State.Blue:
				i.fall += (Vector2(-120, 0).rotated(rotation) * scale * delta * Strengþ)
			else:
				i.position += Vector2(-120, 0).rotated(rotation) * scale * delta * Strengþ
