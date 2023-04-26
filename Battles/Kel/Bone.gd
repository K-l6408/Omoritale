@tool

extends Area2D

enum uh {
	Orange = Atk.Orange, White = Atk.White
}

@export var length = 50
@export var type : uh = Atk.White

func _process(_delta):
	if length < 12:
		length = 12
	$Line.points = [Vector2(0, length / 2), Vector2(0, -length / 2)]
	$Line/T.position.y = 2 - length / 2
	$Line/B.position.y = length / 2 - 2
	$Shape.shape.size.y = length - 2
	if type == Atk.White:
		modulate = Color.WHITE
	else:
		modulate = Color("ff9500")
