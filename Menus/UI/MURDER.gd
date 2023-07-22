extends Area2D

var time = 0
var KILL = true

func _process(delta):
	if get_parent().name != "FIGHT":
		time += delta
		match Globals.WEPN:
			Globals.Weapon.Stick:
				if position.y < 200:
					modulate.a -= delta
				if modulate.a <= 0:
					queue_free()
				position.y -= 200 * delta
			Globals.Weapon.RedKnife:
				pass
