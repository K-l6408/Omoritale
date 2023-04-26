@tool
extends "res://Bullet Boards/BulletPongon.gd"

var time = 0

func _process(delta):
	time += delta
	Polygon = [
		Vector2(+50 +49 * sin(time), -150),
		Vector2(+50 +49 * sin(time), -100),
		Vector2(+50 -49 * sin(time), -100),
		Vector2(+50 -49 * sin(time), - 50),
		Vector2(+50 +49 * sin(time), - 50),
		Vector2(+50 +49 * sin(time),    0),
		Vector2(+50 -49 * sin(time),    0),
		Vector2(+50 -49 * sin(time),   50),
		Vector2(+50 +49 * sin(time),   50),
		Vector2(+50 +49 * sin(time),  100),
		Vector2(+50 -49 * sin(time),  100),
		Vector2(+50 -49 * sin(time),  150),
		Vector2(-50 -49 * sin(time),  150),
		Vector2(-50 -49 * sin(time),  100),
		Vector2(-50 +49 * sin(time),  100),
		Vector2(-50 +49 * sin(time),   50),
		Vector2(-50 -49 * sin(time),   50),
		Vector2(-50 -49 * sin(time),    0),
		Vector2(-50 +49 * sin(time),    0),
		Vector2(-50 +49 * sin(time), - 50),
		Vector2(-50 -49 * sin(time), - 50),
		Vector2(-50 -49 * sin(time), -100),
		Vector2(-50 +49 * sin(time), -100),
		Vector2(-50 +49 * sin(time), -150)
	]
