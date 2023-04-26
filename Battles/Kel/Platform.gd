@tool
extends AnimatableBody2D

@export var length = 60.0
@export var CollisionLayer : int = 1

func _ready():
	pass

func _process(_delta):
	$L1.points = [Vector2(-length / 2, 0), Vector2(length / 2, 0)]
	$L1/L2.points = [Vector2(2 - length / 2, 0), Vector2(length / 2 - 2, 0)]
	$cS.shape.a = Vector2(-length / 2, 0)
	$cS.shape.b = Vector2(length / 2, 0)
	set_collision_layer(CollisionLayer)
	set_collision_mask(CollisionLayer)
	if CollisionLayer == 1:
		$L1.default_color = Color("008202")
	elif CollisionLayer == 2:
		$L1.default_color = Color("611fb0")
	else:
		$L1.default_color = Color("000000")
