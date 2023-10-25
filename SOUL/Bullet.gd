extends Area2D

var Obj : Node

func _process(delta):
	var vel = Vector2.DOWN.rotated(rotation) * 500 * delta
	vel.x *= global_scale.x
	vel.y *= global_scale.y
	position += vel

func start(pos, ang, obj):
	var sc = scale.y
	global_position = pos
	rotation = ang
	var tw = create_tween()
	if tw:
		scale.y = 0
		tw.tween_property(self, "scale:y", sc, 0.6)
	Obj = obj

func Collision(area):
	var h = area.get("atkType")
	if h == null:
		h = 0
	if h & Atk.Shoot:
		area.Shoot()
		queue_free()
		Obj.emit_signal("TP", 1)
