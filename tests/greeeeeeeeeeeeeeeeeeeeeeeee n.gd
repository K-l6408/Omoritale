extends Node2D

@export var shields : Array[bool] = [true,false,false,false]
@export var attack : Array[Vector4] = []
const GSB = preload("res://Battles/Aubrey/GreenSoulBullet.tscn")

func _ready():
	$Soul.first_shield  = shields[0]
	$Soul.second_shield = shields[1]
	$Soul.third_shield  = shields[2]
	$Soul.fourth_shield = shields[3]
	for i in attack:
		var a = GSB.instantiate()
		a.which_shield = int(i.x)
		a.distance = i.y * i.z * 40
		a.speed = i.z * 40
		a.direction = i.w
		a.soul_position = $Soul.position
		add_child(a)
