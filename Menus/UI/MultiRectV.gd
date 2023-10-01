@tool
extends ColorRect

@export var DC : Color
@export var E : PackedVector2Array = []

func _draw():
	for i in E:
		draw_rect(Rect2(-5, i.x-5, size.x+10, (i.y - i.x)+10), DC)
	for i in E:
		draw_rect(Rect2(0, i.x, size.x, (i.y - i.x)), Color.BLACK)

func _process(delta):
	queue_redraw()
