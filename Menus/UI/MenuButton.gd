@tool
extends TextureButton

@export var pain = false
@export var texture : Texture
const pain_texture = preload("res://Assets/UI/PAIN.png")

func _process(delta):
	texture_normal = pain_texture if pain else texture
	if has_focus() and Input.is_action_just_pressed("ui_accept"):
		emit_signal("pressed_pain" if pain else "pressed_regular")

signal pressed_regular()
signal pressed_pain()
