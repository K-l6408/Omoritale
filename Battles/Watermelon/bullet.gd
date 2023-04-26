extends Area2D

var velocity : Vector2
var damage = 5
var distance = 0
var keep_going = false

func _process(delta):
	rotation += delta * 15
	position += delta * velocity
	distance -= delta * velocity.length()
	if distance <= 0 and not keep_going:
		velocity = Vector2(0, 0)
		emit_signal("reached", self)
	if damage < 0:
		modulate = Color.GREEN_YELLOW
	else:
		modulate = Color.WHITE

func go_towards(nextpos:Vector2, pxps, keepgoing:=true):
	velocity = (nextpos - position).normalized() * pxps
	distance = position.distance_to(nextpos)
	keep_going = keepgoing

signal reached(me)
