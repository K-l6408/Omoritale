extends Area2D

@onready var PLAYER    = %Sunnisk
@onready var MELONY    = %Melony
@export  var source    = ""
@export  var label     = ""
@export  var soulStart = Vector2(480, 360)
@export  var nextScene = ""

func start_cutscene_eval(body):
	if body != PLAYER:
		return
	MELONY.show()
	MELONY.play("appear")
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	body.TextBox.start(load(source), label)
	await body.TextBox.finished
	await body.BattleStart(soulStart)
	get_tree().change_scene_to_file(nextScene)
