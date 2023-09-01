@tool
extends StaticBody2D
@export var StartingPolygon : PackedVector2Array
@export var TargetPolygon   : PackedVector2Array
@export var BGColor := Color.BLACK
@export var TimeItTakes     := 1.0
@export var CollisionLayer  := 1
var time = 0
var Polygon := StartingPolygon
var lerping = false

func _physics_process(delta):
	if Engine.is_editor_hint():
		Polygon = StartingPolygon
	var pongon = Polygon.duplicate()
	if not pongon.is_empty():
		pongon.append(pongon[0])
	if TimeItTakes > 0 and not Engine.is_editor_hint():
		if Polygon.is_empty():
			Polygon = TargetPolygon.duplicate()
		elif lerping:
			if smoothify(StartingPolygon, TargetPolygon, delta / TimeItTakes):
				emit_signal("smoothed")
				lerping = false
	$CollisionPolygon2D.polygon = Polygon
	$Polygon2D.polygon = Polygon
	$Line2D.points = pongon
	collision_layer = CollisionLayer
	collision_mask  = CollisionLayer
	if Engine.is_editor_hint():
		$Line2D.default_color = Color.MAGENTA
	else:
		match CollisionLayer:
			1:
				$Line2D.default_color = Globals.Colors["DarkGreen"]
			2:
				$Line2D.default_color = Globals.Colors["DarkOrange"]
			3:
				$Line2D.default_color = Globals.Colors["LightTeal"]
	$Polygon2D.self_modulate = BGColor

func smoothify( pongon1:PackedVector2Array,\
				pongon2:PackedVector2Array, delta:float):
	time += delta
	if pongon1.size() != pongon2.size():
		return false
	var h := 0
	var result : PackedVector2Array = []
	for p in pongon1.size():
		var point1 = pongon1[p]
		var point2 = pongon2[p]
		if (point1 - point2).length_squared() < 10:
			result.append(point2)
			h += 1
		else:
			var l = lerp(point1, point2, time)
			if (point1 - l).length_squared() > (point1 - point2).length_squared():
				result.append(point2)
				h += 1
			else:
				result.append(l)
	if h >= pongon1.size():
		Polygon = pongon2
		return true
	Polygon = result
	return false

func Interpolate(start:PackedVector2Array, end:PackedVector2Array, tt = 1.0):
	time = 0
	lerping = true
	if start.size() != end.size():
		return false
	StartingPolygon = start
	TargetPolygon = end
	TimeItTakes = tt
	await smoothed
	return true

signal smoothed()
