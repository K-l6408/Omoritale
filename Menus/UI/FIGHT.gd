extends Control

var G = 1

func _ready():
	$Balloon/Rect.color = Color(1,1,1)
	for e in Globals.Enemies:
		pass

func _process(delta):
	$Balloon/Rect.color = Color(1, max(51./255, G), max(51./255, G))
	G -= delta
