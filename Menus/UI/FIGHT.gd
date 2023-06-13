extends Control

var G = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Balloon/Rect.color = Color(1,1,1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Balloon/Rect.color = Color(1, max(51./255, G), max(51./255, G))
	G -= delta
