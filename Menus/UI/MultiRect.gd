@tool
extends ColorRect

@export var DC : Color
@export var E : PackedVector2Array = []

func _draw():
	for i in E:
		draw_rect(Rect2(i.x-5, -5, i.y+10, size.y+10), DC)
	for i in E:
		draw_rect(Rect2(i.x, 0, i.y, size.y), Color.BLACK)
