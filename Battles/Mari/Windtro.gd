extends Node2D

func _ready():
	$Box.ChangeSize(Vector2(200, 200), 1)
	for i in 12:
		var L = $Leaf.duplicate()
		L.show()
		%Leaves.add_child(L)
		L.position = Vector2(-i * 200 - 600, randi_range(-100, 100))
	await get_tree().create_timer((12*200+600)/250).timeout
	$Box.ChangeSize(Vector2(900, 200), .3)
	await get_tree().create_timer(.3).timeout
	queue_free()

func _physics_process(delta):
	%Leaves.position.x += 250 * delta

func ow(ðe):
	emit_signal("hit", ðe)

signal hit(ðe)
