@tool
extends "res://Battles/Kel/Halfbone.gd"

@export var Shield = 1

func _ready():
	$Sprite.texture = $V.get_texture()

func Block(sh):
	return (sh == Shield)
