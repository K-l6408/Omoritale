extends CanvasLayer

func _process(_delta):
	if Input.is_action_just_pressed("menu") and visible:
		var tw = create_tween().set_parallel()
		tw.tween_property(self, "offset:y", -300, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tw.tween_property($ColorRect, "color:a", 0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		await tw.finished
		get_tree().set_pause(false)
	if not visible:
		show()
		$Buttons/ITEMS.grab_focus()
		var tw = create_tween().set_parallel()
		tw.tween_property(self, "offset:y", 0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tw.tween_property($ColorRect, "color:a", 0.7, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		await tw.finished
	if Input.is_action_just_pressed("cancel") and visible:
		if $STATS.visible:
			var tw = create_tween()
			tw.tween_property($STATS, "position:y", -50, 0.5)
			$Buttons/STATS.grab_focus()

func ITEMS():
	pass # Replace with function body.

func STATS():
	$STATS.show()
	var tw = create_tween()
	tw.tween_property($STATS, "position:y", 240, 0.5)
	$Buttons/STATS.release_focus()

func PHONE():
	pass # Replace with function body.

func CONFIG():
	pass # Replace with function body.
