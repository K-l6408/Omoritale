extends CanvasGroup
var okay = false

func _ready():
	if Globals.AcceptKey == "" or Globals.CancelKey == "" or Globals.MenuKey == "":
		$Button.show()
	else:
		$Label.text = "[Press %s]" % Globals.AcceptKey
		$Button.hide()
		okay = true

func _process(delta):
	$Label.modulate.a = abs(sin(Time.get_ticks_msec() / 500.))
	if okay and Input.is_action_pressed("accept"):
		var anim = create_tween()
		anim.tween_property(self, "position:y", 720, .7)
		await anim.finished
#		get_tree().change_scene_to_file("res://Menus/???.tscn")

func configure_inputs():
	var anim = create_tween()
	anim.tween_property(self, "position:x", 960, .7)
	await anim.finished
	get_tree().change_scene_to_file("res://Menus/Config.tscn")

signal anim(a)
