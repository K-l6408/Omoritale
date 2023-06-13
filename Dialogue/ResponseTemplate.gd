extends RichTextLabel

func _process(_delta):
	$Soul.visible = has_focus()
