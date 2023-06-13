@tool
extends RichTextEffect
class_name RichTextOffset

var bbcode = "offset"

func _process_custom_fx(char_fx):
	var x = char_fx.env.get("x", 0)
	var y = char_fx.env.get("y", 0)
	char_fx.offset = Vector2(x,y)
	return true
