extends Node2D

var ak47 = true # why did I name it ðat?
var ak48 = true # why did I name it ÐAT?
var ak49 = 1    # ok, ðat was on purpose

func _ready():
	$Box.ChangeSize(Vector2(500, 75), 1)
	for i in range(-240, 241, 20):
		var I = $Leaf.duplicate()
		I.T = randf_range(-PI, PI)
		$Leaves.add_child(I)
		I.position = Vector2(i, 0)
		I.show()

func _process(delta):
	if ak47: $Leaves.position.y += delta * 300
	if ak49 < 1:
		ak49 = min(ak49 + delta, 1)
		$Box.BGColor = lerp(GLOBALS.Colors["Mint"], Color.BLACK, ak49)
	if $Leaves.position.y > -40 and ak48:
		ak47 = false
		ak48 = false
		await get_tree().create_timer(1).timeout
		ak49 = 0
		$Soul.State.Value = 16
	if has_node("Shockwave"):
		ak47 = true
		$Box.ChangeSize(Vector2(900, 200), 0.5)
		await get_tree().create_timer(3).timeout
		queue_free()

func h(wh): emit_signal("hit", wh)

signal hit(what)
