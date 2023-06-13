extends Area2D

const atkType = Atk.White
var velocity : Vector2
var smooth = false
var damage = 5
var fract = 0
var total_dist = 0
var keep_going = false

func _process(delta):
	rotation += delta * 10
	position += delta * velocity
	fract += (delta * velocity.length()) / total_dist
	if fract >= 1 and not keep_going:
		velocity = Vector2(0, 0)
		emit_signal("reached", self)
	if smooth:
		modulate = Color(fract*2, 1, fract*2, 1)
	elif damage < 0:
		modulate = Color.GREEN
	else:
		modulate = Color.WHITE

func go_towards(nextpos:Vector2, pxps, keepgoing:=true):
	velocity = (nextpos - position).normalized() * pxps
	total_dist = position.distance_to(nextpos)
	fract = 0
	keep_going = keepgoing

signal reached(me)
