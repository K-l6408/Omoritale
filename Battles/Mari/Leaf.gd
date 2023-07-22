extends Area2D

enum uh {
	White = Atk.White, Mint = Atk.White | Atk.Shock
}

@export var atkType : uh = uh.White
@export var attacker = "Mari"
@export var damage = -3
var T = 0

func _process(delta):
	if atkType == uh.White:
		modulate = Color.WHITE
	else: modulate = GLOBALS.Colors["DarkMint"]
	T += delta
	rotation = cos(T) - .5

func Shock():
	queue_free()
