@tool
extends Control
@export var PlayerStats     : Stats 
@export var EffectColors    : PackedColorArray = []
@export var StatusEffects   : PackedStringArray = []
@export var LevelOfViolence := 1
@export var DialogueSource := "res://Dialogue/"
@export var DialogueText   := ""
var T = 1
var C  := Color.WHITE
var TC := Color.WHITE
var EffectNum : int
var Fightscn = preload("res://Menus/UI/FIGHT.tscn")
var Actscn   = preload("res://Menus/UI/ACT.tscn")
var Skillscn = preload("res://Menus/UI/SKILL.tscn")

func _ready():
	EffectNum = min(PlayerStats.EHP.size(),PlayerStats.EJP.size())
	$TextBox/Balloon.position = position + Vector2(30, 333)
	for c in EffectNum:
		var e = ColorRect.new()
		e.color = EffectColors[c]
		e.anchors_preset = PRESET_RIGHT_WIDE
		e.size.y = 50
		$HP/Bar.add_child(e)
	for c in EffectNum:
		var e = ColorRect.new()
		e.color = EffectColors[c]
		e.anchors_preset = PRESET_RIGHT_WIDE
		e.size.y = 50
		$JP/Bar.add_child(e)
	$HP/Bar       .size.x = 0
	$JP/Bar       .size.x = 0
	$HP           .size.x = 0
	$JP           .size.x = 0

func playerTurn(defclr := GLOBALS.Colors["Green"]):
	C = defclr
	TC = Color.WHITE
	dialogue()
	T = 0
	await $TextBox.finished
	$TextBox.show()
	$TextBox/Balloon/Margin/VBox.hide()
	$Buttons/FIGHT.grab_focus()

func dialogue():
	$TextBox.show()
	$TextBox/Balloon/Margin/VBox.show()
	$TextBox.start(load(DialogueSource), DialogueText)

func _process(delta):
	T += delta
	if Engine.is_editor_hint():
		PlayerStats. HP = GLOBALS.MHPfromLV(LevelOfViolence)
		PlayerStats.MHP = GLOBALS.MHPfromLV(LevelOfViolence)
		PlayerStats.MJP = GLOBALS.MJPfromLV(LevelOfViolence)
	EffectNum = min(PlayerStats.EHP.size(),PlayerStats.EJP.size())
	$HP           .size.x = lerpf($HP           .size.x, PlayerStats.MHP * 1.2, delta * 5)   
	$HP/Bar       .size.x = lerpf($HP/Bar       .size.x, PlayerStats. HP * 1.2, delta * 2)
	$JP           .size.x = lerpf($JP           .size.x, PlayerStats.MJP * 1.2, delta * 5)
	$JP/Bar       .size.x = lerpf($JP/Bar       .size.x, PlayerStats. JP * 1.2, delta * 2)
	$JP           .position.x = 906 - $JP.size.x
	$JP/Bar       .position.x = $JP.size.x - $JP/Bar.size.x
	$Effect.text = "[center]"
	var h = 0
	var j = 0
	for e in EffectNum:
		$Effect.text += "[color=#" + EffectColors[e].to_html(false) + "]" + StatusEffects[e] + "[/color]\n"
		$HP/Bar.get_child(e).size.x = lerpf($HP/Bar.get_child(e).size.x, PlayerStats.EHP[e] * 1.2, delta * 2)
		$JP/Bar.get_child(e).size.x = lerpf($JP/Bar.get_child(e).size.x, PlayerStats.EJP[e] * 1.2, delta * 2)
		h += $HP/Bar.get_child(e).size.x
		$HP/Bar.get_child(e).position.x = $HP/Bar.size.x - h
		$JP/Bar.get_child(e).position.x = j
		j += $JP/Bar.get_child(e).size.x
	$Effect.text += "[/center]"
	$LV.text = "LV " + str(LevelOfViolence)
	$TextBox/Balloon/Rect.modulate = lerp(C, TC, T)

func Fight():
	$Buttons/FIGHT.release_focus()
	$TextBox.hide()
	var F = Fightscn.instantiate()
	F.position = Vector2(0, 0)
	F.set_deferred("size", Vector2(960, 720))
	add_child(F)
	F.connect("nvm", func():
		playerTurn(F.get_node("Rect").DC)
		F.queue_free()
	)
	F.connect("done", func(): emit_signal("YourTurn"))

func Act():
	$Buttons/ACT.release_focus()
	$TextBox.hide()
	var A = Actscn.instantiate()
	add_child(A)
	A.connect("nvm", func():
		playerTurn(A.get_node("ACT/Rect").color)
		A.queue_free()
	)
	A.connect("act", func(enm,act):
		await A.done
		emit_signal("Ask", enm, act)
		C  = A.get_node("ACT/Rect").color
		TC = A.get_node("ACT/Rect").color
		if $TextBox.visible:
			await $TextBox.finished
			TC = Globals.Colors["DarkGreen"]
		emit_signal("YourTurn")
	)

func Skill():
	$Buttons/SKILL.release_focus()
	$TextBox.hide()
	var S = Skillscn.instantiate()
	add_child(S)
#	S.connect("nvm", func():
#		playerTurn(S.get_node("ACT/Rect").color)
#		S.queue_free()
#	)
#	S.connect("act", func(enm,act):
#		await S.done
#		emit_signal("Ask", enm, act)
#		C  = S.get_node("ACT/Rect").color
#		TC = S.get_node("ACT/Rect").color
#		if $TextBox.visible:
#			await $TextBox.finished
#			TC = Globals.Colors["DarkGreen"]
#		emit_signal("YourTurn")
#	)

signal YourTurn()
signal Ask(enm, act)
signal What()
