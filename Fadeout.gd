extends ColorRect

func _ready():
	color.a = 1

func _process(delta):
	color.a -= delta
