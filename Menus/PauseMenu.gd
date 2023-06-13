extends CanvasLayer

func _ready():
	pass

func _process(_delta):
	if Input.is_action_just_pressed("menu") and visible:
		var tw = create_tween()
		tw.tween_property(self, "offset:y", -300, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		await tw.finished
		get_tree().set_pause(false)
	if not visible:
		show()
		$Buttons/ITEMS.grab_focus()
		var tw = create_tween()
		tw.tween_property(self, "offset:y", 0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		await tw.finished

func ITEMS():
	pass # Replace with function body.

func STATS():
	pass # Replace with function body.

func PHONE():
	pass # Replace with function body.

func CONFIG():
	pass # Replace with function body.
