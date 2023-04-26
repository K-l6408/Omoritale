extends Node2D

var HP := 26
var JP := 16
var debug = 0
var bulletpos = [
	Vector2(400, 260),
	Vector2(450, 240),
	Vector2(510, 240),
	Vector2(560, 260)
]
@onready var bullet = $BulletTemplate

# Called when the node enters the scene tree for the first time.
func _ready():
	$TextBox.start(load("res://Dialogue/materwelon.dialogue"), "battle")
	$HP    .size.x = 0
	$JP    .size.x = 0
	$HP/Bar.size.x = 0
	$JP/Bar.size.x = 0

func _process(delta):
	$HP/Bar.size.x = lerpf($HP/Bar.size.x, HP * 1.2, delta * 2)
	$JP/Bar.size.x = lerpf($JP/Bar.size.x, JP * 1.2, delta * 2)
	$HP    .size.x = lerpf($HP    .size.x, 26 * 1.2, delta * 5)
	$JP    .size.x = lerpf($JP    .size.x, 16 * 1.2, delta * 5)
	$JP    .position.x = 906 - $JP.size.x
	$JP/Bar.position.x = $JP.size.x - $JP/Bar.size.x
	if debug == 0 and Globals.debugAttack == 1:
		debug = 1
		for i in 4:
			var b = bullet.duplicate(5)
			add_child(b)
			b.go_towards(bulletpos[i], 50, false)
			b.show()
			b.connect("reached", target)

func target(who):
	who.go_towards($Soul.position, 50)

func ouch(damage):
	HP -= damage
