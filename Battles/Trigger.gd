extends Area2D

@onready var PLAYER    = %Sunnisk
@onready var MELONY    = %Melony
@export  var source    = ""
@export  var label     = ""
@export  var soulStart = Vector2(480, 360)
@export  var nextScene = "res://Battles/Watermelon/Watermelon1.tscn"

func start_cutscene_eval(body):
	if body != PLAYER:
		return
	MELONY.show()
	MELONY.play("appear")
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	%Audio.play()
	body.TextBox.start(load(source), label)
	await body.TextBox.finished
	await body.BattleStart(soulStart)
	Globals.musynctime = %Audio.get_playback_position()
	get_tree().change_scene_to_file(nextScene)
