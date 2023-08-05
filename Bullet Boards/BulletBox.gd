@tool
extends CanvasGroup
@export var Size: Vector2
@export var BGColor := Color.BLACK
@export var CollisionLayer = 1
var T = 0
var D = 1
var S = Size
var N = Size

func _ready():
	InstChangeSize(Size)

func _process(delta):
	$Walls.collision_layer = 1 << (CollisionLayer - 1)
	$Walls.collision_mask  = 1 << (CollisionLayer - 1)
	if Engine.is_editor_hint():
		$Green.default_color = Color.MAGENTA
	else:
		match CollisionLayer:
			1:
				$Green.default_color = Globals.Colors["DarkGreen"]
			2:
				$Green.default_color = Globals.Colors["DarkOrange"]
			3:
				$Green.default_color = Globals.Colors["LightTeal"]
		if Size != N:
			T += delta * D
			if T > 1: T = 1
			InstChangeSize(lerp(S, N, T))
			SizeChanged()
	$Black.color = BGColor

func ChangeSize(_N : Vector2, _T : float):
	S = Size
	T = 0
	N = _N
	D = 1/_T

func InstChangeSize(_N : Vector2):
	for j in get_children():
		j.position = -_N/2
	Size = _N
	SizeChanged()

func SizeChanged():
	var HCollision = $Walls/T.shape
	HCollision.a = Size.x/2 * Vector2.LEFT
	HCollision.b = Size.x/2 * Vector2.RIGHT
	var VCollision = $Walls/L.shape
	VCollision.a = Size.y/2 * Vector2.UP
	VCollision.b = Size.y/2 * Vector2.DOWN
	
	$Green.points = [0, Size * Vector2(0,1), Size, Size * Vector2(1,0), 0]
	$Black.size = Vector2(Size.x, Size.y)
	$Walls/T.position  = Vector2(Size.x / 2, 0)
	$Walls/B.position  = Vector2(Size.x / 2, Size.y)
	$Walls/L.position  = Vector2(0, Size.y / 2)
	$Walls/R.position  = Vector2(Size.x, Size.y / 2)
