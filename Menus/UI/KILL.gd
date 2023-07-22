extends Sprite2D

var time = 0
var process = false
var select = false
var next : Node
var murd : Node
var thx

func _process(delta):
	if not process: return
	visible = true
	if time < 0:
		time += delta
		if time >= 0:
			time = 0
	else:
		time += delta
		match Globals.WEPN:
			Globals.Weapon.Stick:
				if time < 1:
					position.y -= cos(time * PI / 2) * PI * 100 * delta
				elif time > 1.5:
					position.x += delta * 250
					if position.x > 950:
						if next: next.select = true
						queue_free()
		if select and Input.is_action_just_pressed("accept"):
			await get_tree().process_frame
			if next: next.select = true
			select = false
			var M = murd.duplicate()
			M.global_position = global_position
			if Globals.WEPN == Globals.Weapon.RedKnife:
				emit_signal("hey", self)
				M.closest = thx
			M.show()
			add_sibling(M)
			queue_free()

signal hey(itsme)
