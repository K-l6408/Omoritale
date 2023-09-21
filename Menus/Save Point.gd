extends Area2D

const SAVE = true
@export var Place = "[???]"

func _ready():
	$AnimatedSprite2D.play("default")

func _process(delta):
	$Balloon/N.text = Globals.PlayerName
	$Balloon/L.text = "LV %d" % Globals.lastsaverelevantdata["LV"]
	$Balloon/W.text = Globals.AREA
	var t = int(Globals.lastsaverelevantdata["TIME"])
	$Balloon/T.text = "%03d:%02d:%02d" % [(t-t%3600)/3600, (t-t%60)/60, t%60]
	if Input.is_action_just_pressed("ui_accept") and $Balloon.visible: emit_signal("okay")

func Save():
	$Balloon.show()
	$Balloon/Yes.grab_focus()
	$Balloon/Yes.show()
	$Balloon/No .show()
	$Balloon/OK .hide()
	await $Balloon.hidden

func yessave():
	Globals.AREA = Place
	Globals.Fsave(Globals.SaveSlot)
	Globals.lastsaverelevantdata["LV"] = Globals.LV
	Globals.lastsaverelevantdata["TIME"] = Globals.TIME
	$Balloon.modulate = Color.YELLOW
	$Balloon/Yes.hide()
	$Balloon/No .hide()
	$Balloon/OK .show()
	await okay
	$Balloon.hide()
	$Balloon.modulate = Color.WHITE

func nosave():
	$Balloon.hide()

signal okay()
