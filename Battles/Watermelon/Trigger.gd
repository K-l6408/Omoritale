extends Area2D

@onready var PLAYER    = %Sunnisk
@onready var MELONY    = %Melony
@export  var source    = ""
@export  var label     = ""
@export  var soulStart = Vector2(480, 360)
@export  var nextScene = "res://Battles/Watermelon/Watermelon1.tscn"

func _ready():
	if Globals.PlayerPosition != Vector2(0, 0):
		$CollisionPolygon2D.disabled = true
		PLAYER.position = Globals.PlayerPosition
		if Globals.PLOT < 1: Globals.PLOT = 1

func start_cutscene_eval(body):
	if body != PLAYER: return
	MELONY.show()
	MELONY.play("appear")
	$CollisionPolygon2D.set_deferred("disabled", true)
	%Audio.play()
	body.TextBox.start(load(source), label)
	await body.TextBox.finished
	await body.BattleStart(soulStart)
	Globals.musynctime = %Audio.get_playback_position()
	Globals.PlayerPosition = PLAYER.position
	get_tree().change_scene_to_file(nextScene)
