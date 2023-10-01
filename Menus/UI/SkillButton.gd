extends Button

@export var wha : int

func _process(_delta):
	$Soul.visible = has_focus()

func _pressed():
	emit_signal("go", wha)

signal go(whar)
