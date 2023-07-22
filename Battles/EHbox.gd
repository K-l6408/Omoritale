extends Area2D

@export var Stat = Stats.new()

func _ready():
	connect("area_entered", ouch)

func ouch(area):
	if area.get("KILL") != null:
		var j = abs(area.global_position.x - global_position.x) * 2
		emit_signal("hurt", 1 - j / $Shape.shape.size.x)

signal hurt(intensity)
