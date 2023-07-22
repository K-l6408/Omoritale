@tool
extends CanvasGroup
@export var Size: Vector2
@export var BGColor := Color.BLACK
@export var CollisionLayer = 1
var size = Size

func _ready():
	size = Size
	changeSize(Size, .1/6)

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
	$Black.color = BGColor
	if Size != size:
		changeSize(Size, delta)
		sizeChanged()
	if has_node("Hide"):
		$Hide.size            = $Black.size
		$Hide.global_position = $Black.global_position
		$Hide.clip_contents = true
		$Hide.color = Color.BLACK

func changeSize(N : Vector2, dt):
	InstChangeSize(lerp(size, N, dt*3))

func InstChangeSize(N : Vector2):
	for j in get_children():
		j.position = -N/2
	size = N
	sizeChanged()

func sizeChanged():
	var HCollision = $Walls/T.shape
	HCollision.a = size.x/2 * Vector2.LEFT
	HCollision.b = size.x/2 * Vector2.RIGHT
	var VCollision = $Walls/L.shape
	VCollision.a = size.y/2 * Vector2.UP
	VCollision.b = size.y/2 * Vector2.DOWN
	
	$Green.points = [0, size * Vector2(0,1), size, size * Vector2(1,0), 0]
	$Black.size = Vector2(size.x, size.y)
	$Walls/T.position  = Vector2(size.x / 2, 0)
	$Walls/B.position  = Vector2(size.x / 2, size.y)
	$Walls/L.position  = Vector2(0, size.y / 2)
	$Walls/R.position  = Vector2(size.x, size.y / 2)
