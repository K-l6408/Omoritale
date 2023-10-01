@tool
extends "res://Bullet Boards/BulletPongon.gd"

var T = 0
@export var S = Vector2(50, 50)

func _process(delta):
	if Engine.is_editor_hint(): return
	T += delta
	Polygon = [
		Vector2(+S.x +(S.x-1) * sin(T), -3 * S.y),
		Vector2(+S.x +(S.x-1) * sin(T), -2 * S.y),
		Vector2(+S.x +(1-S.x) * sin(T), -2 * S.y),
		Vector2(+S.x +(1-S.x) * sin(T),    - S.y),
		Vector2(+S.x +(S.x-1) * sin(T),    - S.y),
		Vector2(+S.x +(S.x-1) * sin(T),        0),
		Vector2(+S.x +(1-S.x) * sin(T),        0),
		Vector2(+S.x +(1-S.x) * sin(T),      S.y),
		Vector2(+S.x +(S.x-1) * sin(T),      S.y),
		Vector2(+S.x +(S.x-1) * sin(T),  2 * S.y),
		Vector2(+S.x +(1-S.x) * sin(T),  2 * S.y),
		Vector2(+S.x +(1-S.x) * sin(T),  3 * S.y),
		Vector2(-S.x +(1-S.x) * sin(T),  3 * S.y),
		Vector2(-S.x +(1-S.x) * sin(T),  2 * S.y),
		Vector2(-S.x +(S.x-1) * sin(T),  2 * S.y),
		Vector2(-S.x +(S.x-1) * sin(T),      S.y),
		Vector2(-S.x +(1-S.x) * sin(T),      S.y),
		Vector2(-S.x +(1-S.x) * sin(T),        0),
		Vector2(-S.x +(S.x-1) * sin(T),        0),
		Vector2(-S.x +(S.x-1) * sin(T),    - S.y),
		Vector2(-S.x +(1-S.x) * sin(T),    - S.y),
		Vector2(-S.x +(1-S.x) * sin(T), -2 * S.y),
		Vector2(-S.x +(S.x-1) * sin(T), -2 * S.y),
		Vector2(-S.x +(S.x-1) * sin(T), -3 * S.y)
	]
