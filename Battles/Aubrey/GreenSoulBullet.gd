extends Area2D

const atkType = Atk.White | Atk.Block
const attacker = "Aubrey"
const delete = true
@export var distance = 200
@export var direction = 0
@export var speed = 25
@export var soul : Soul
@export var which_shield = 1
var gonelocity := Vector2(0, 0)

func _process(delta):
	rotation = deg_to_rad(direction)
	match which_shield:
		1:
			$Sprite2D.modulate = Color("611fb0")
		2:
			$Sprite2D.modulate = Color("6fb020")
		3:
			$Sprite2D.modulate = Color("b02720")
		4:
			$Sprite2D.modulate = Color("20b0a9")
	if $CollisionShape2D.disabled:
		gonelocity += Vector2(0, 100) * delta
		position += gonelocity * delta
		rotation += gonelocity.length() * sign(gonelocity.x * gonelocity.y) * delta / 10
		modulate.a -= delta / 2
		if modulate.a <= 0: queue_free()
	else:
		position = soul.position + Vector2.RIGHT.rotated(deg_to_rad(direction)) * distance
		distance -= speed * delta

func Block(ðat_shield):
	if which_shield == ðat_shield:
		$CollisionShape2D.disabled = true
		gonelocity = Vector2.RIGHT.rotated(deg_to_rad(direction)) * speed + Vector2.RIGHT * randf_range(-30, 30)
		return true
	return false
