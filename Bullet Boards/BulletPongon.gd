@tool
extends StaticBody2D
@export var Polygon        : PackedVector2Array
@export var TargetPolygon  : PackedVector2Array
@export var SmoothingSpeed := 1.0
@export var CollisionLayer := 1

func _physics_process(delta):
	var pongon = Polygon.duplicate()
	if not pongon.is_empty():
		pongon.append(pongon[0])
	if SmoothingSpeed > 0 and not Engine.is_editor_hint():
		if Polygon.is_empty():
			Polygon = TargetPolygon.duplicate()
		else:
			if smoothify(Polygon, TargetPolygon, delta * SmoothingSpeed):
				emit_signal("smoothed")
	$CollisionPolygon2D.polygon = Polygon
	$Polygon2D.polygon = Polygon
	$Line2D.points = pongon
	collision_layer = CollisionLayer
	collision_mask  = CollisionLayer
	if CollisionLayer == 1:
		$Line2D.default_color = Color("008202")
	elif CollisionLayer == 2:
		$Line2D.default_color = Color("611fb0")

func smoothify( pongon1:PackedVector2Array,\
				pongon2:PackedVector2Array, delta:float):
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
			var l = lerp(point1, point2, delta)
			if (point1 - l).length_squared() > (point1 - point2).length_squared():
				result.append(point2)
				h += 1
			else:
				result.append(l)
	if h >= min(pongon1.size(), pongon2.size()):
		Polygon = pongon2
		return true
	Polygon = result
	return false

func Interpolate(start:PackedVector2Array, end:PackedVector2Array, ssp = 1.0):
	if start.size() != end.size():
		return false
	Polygon = start
	TargetPolygon = end
	SmoothingSpeed = ssp
	await smoothed
	return true

signal smoothed()
