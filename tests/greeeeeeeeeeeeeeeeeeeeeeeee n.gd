extends Node2D

@export var shields := { 1: true, 2: false, 3: false, 4: false }
@export var attack : Array[Vector4] = []
const GSB = preload("res://Battles/Aubrey/GreenSoulBullet.tscn")

func _ready():
	$Soul.first_shield  = shields[1]
	$Soul.second_shield = shields[2]
	$Soul.third_shield  = shields[3]
	$Soul.fourth_shield = shields[4]
	for i in attack:
		var a = GSB.instantiate()
		a.which_shield = int(i.x)
		a.distance = i.y * i.z * 40
		a.speed = i.z * 40
		a.direction = i.w
		a.soul = $Soul
		add_child(a)
