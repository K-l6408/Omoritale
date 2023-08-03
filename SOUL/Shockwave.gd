extends Area2D

const Shockwave = true

func _physics_process(delta):
	scale.x += delta
	scale.y += delta
	modulate.a -= delta / 2
	if modulate.a <= 0:
		queue_free()
	for Obj in get_overlapping_areas():
		if zero(Obj.get("atkType")) & Atk.Shock:
			Obj.Shock()

func zero(arg):
	if arg:
		return arg
	else:
		return 0
