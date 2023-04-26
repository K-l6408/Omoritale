extends Node2D

func _ready():
	$Pongon.Interpolate([
		Vector2(-1200, -200),
		Vector2(- 101, -200),
		Vector2(- 100,  160),
		Vector2(-  99, -200),
		Vector2(  400, -200),
		Vector2(  400, -400),
		Vector2(  600, -400),
		Vector2(  600, -600),
		Vector2(  800, -600),
		Vector2(  800,  200),
		Vector2(-1200,  200)
	],[
		Vector2(- 101, -200),
		Vector2(- 101, -200),
		Vector2(- 100,  160),
		Vector2(-  99, -200),
		Vector2(  400, -200),
		Vector2(  400, -400),
		Vector2(  600, -400),
		Vector2(  600, -600),
		Vector2(  800, -600),
		Vector2(  800,  200),
		Vector2(- 100,  200)
	], 0.1)
