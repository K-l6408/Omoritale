@tool
extends "res://Bullet Boards/BulletPongon.gd"

var T = 0

func _process(delta):
	T += delta
	Polygon = [
		Vector2(+50 +49 * sin(T), -150),
		Vector2(+50 +49 * sin(T), -100),
		Vector2(+50 -49 * sin(T), -100),
		Vector2(+50 -49 * sin(T), - 50),
		Vector2(+50 +49 * sin(T), - 50),
		Vector2(+50 +49 * sin(T),    0),
		Vector2(+50 -49 * sin(T),    0),
		Vector2(+50 -49 * sin(T),   50),
		Vector2(+50 +49 * sin(T),   50),
		Vector2(+50 +49 * sin(T),  100),
		Vector2(+50 -49 * sin(T),  100),
		Vector2(+50 -49 * sin(T),  150),
		Vector2(-50 -49 * sin(T),  150),
		Vector2(-50 -49 * sin(T),  100),
		Vector2(-50 +49 * sin(T),  100),
		Vector2(-50 +49 * sin(T),   50),
		Vector2(-50 -49 * sin(T),   50),
		Vector2(-50 -49 * sin(T),    0),
		Vector2(-50 +49 * sin(T),    0),
		Vector2(-50 +49 * sin(T), - 50),
		Vector2(-50 -49 * sin(T), - 50),
		Vector2(-50 -49 * sin(T), -100),
		Vector2(-50 +49 * sin(T), -100),
		Vector2(-50 +49 * sin(T), -150)
	]
