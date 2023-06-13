@tool

extends Area2D

enum uh {
	Orange = Atk.Orange, White = Atk.White
}

@export var length = 50
@export var atkType : uh = uh.White
@export var damage = 3
@export var CollisionLayer := 1

func _ready():
	$Shape.shape = RectangleShape2D.new()

func _process(_delta):
	collision_layer = 1 << (CollisionLayer - 1)
	collision_mask  = 1 << (CollisionLayer - 1)
	$V.size.y = length + 4
	if length < 8:
		length = 8
	$V/Line.points = [Vector2(0, 0), Vector2(0, length)]
	$V/Line/T.position.y = length - 2
	$Shape.shape.size = Vector2(4, length - 2)
	$Shape.position.y = -length / 2
	$"Sprite/2".region_rect.size.y = length + 4
	if atkType == Atk.White:
		modulate = Color.WHITE
	else:
		modulate = Globals.Colors["Orange"]
	if not Engine.is_editor_hint():
		match CollisionLayer:
			1:
				$"Sprite/2".modulate = Color.WHITE
			2:
				$"Sprite/2".modulate = Globals.Colors["DarkOrange"]
			3:
				$"Sprite/2".modulate = Globals.Colors["LightTeal"]
