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
	$Sprite.texture = $V.get_texture()

func _process(_delta):
	collision_layer = 1 << (CollisionLayer - 1)
	collision_mask  = 1 << (CollisionLayer - 1)
	if length < 12:
		length = 12
	$V/Line.points = [Vector2(0, length / 2.), Vector2(0, -length / 2.)]
	$V/Line/T.position.y = 2 - length / 2.
	$V/Line/B.position.y = length / 2. - 2
	$V/Line.position.y = length / 2 + 4
	$V.size.y = length + 8
	$Shape.shape.size = Vector2(4, length - 2)
	$"Sprite/2".region_rect.size.y = length + 8
	if atkType == Atk.White:
		$Sprite.self_modulate = Color.WHITE
	else:
		$Sprite.self_modulate = Globals.Colors["Orange"]
	if not Engine.is_editor_hint():
		match CollisionLayer:
			1:
				$"Sprite/2".modulate = Color.WHITE
			2:
				$"Sprite/2".modulate = Globals.Colors["DarkOrange"]
			3:
				$"Sprite/2".modulate = Globals.Colors["LightTeal"]

