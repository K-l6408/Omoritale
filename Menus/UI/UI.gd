@tool
extends Control
@export var PlayerStats     : Stats 
@export var LevelOfViolence : float = 1
@export var DialogueSource := "res://Dialogue/"
@export var DialogueText   := ""
@export var MenuAttack     := 0
var T = 1
var C  := Color.WHITE
var TC := Color.WHITE
var EffectNum : int
var Fightscn = preload("res://Menus/UI/FIGHT.tscn")
var Actiŋscn = preload("res://Menus/UI/ACT.tscn")
var Skillscn = preload("res://Menus/UI/SKILL.tscn")
var Mercyscn = preload("res://Menus/UI/MERCY.tscn")

func _ready():
	$TextBox/Balloon.position = position + Vector2(30, 333)
	for c in PlayerStats.EFF.size():
		var e = ColorRect.new()
		e.color = PlayerStats.EFF[c].color
		e.anchors_preset = PRESET_RIGHT_WIDE
		e.size.y = 50
		$HP/Bar.add_child(e)
	for c in PlayerStats.EFF.size():
		var e = ColorRect.new()
		e.color = PlayerStats.EFF[c].color
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
	for i in $Buttons.get_children(): i.disabled = false
	await get_tree().process_frame
	await get_tree().process_frame
	$Buttons/FIGHT.grab_focus()

func dialogue():
	$TextBox.show()
	$TextBox/Balloon/Margin/VBox.show()
	$TextBox.start(load(DialogueSource), DialogueText)

func _process(delta):
	T += delta
	if MenuAttack > 0:
		for i in $Buttons.get_child_count():
			$Buttons.get_child(i).pain = int((int(i*MenuAttack) - int(T*2)) % 5 / float(MenuAttack % 4 if MenuAttack % 4 else 4)) == 0
	else:
		for i in $Buttons.get_children(): i.pain = false
	if Engine.is_editor_hint():
		PlayerStats. HP = float(GLOBALS.MHPfromLV(LevelOfViolence))
		PlayerStats.MHP = float(GLOBALS.MHPfromLV(LevelOfViolence))
		PlayerStats.MJP = float(GLOBALS.MJPfromLV(LevelOfViolence))
	$HP           .size.x = lerpf($HP           .size.x, PlayerStats.MHP * 1.2, delta * 7)   
	$HP/Bar       .size.x = lerpf($HP/Bar       .size.x, PlayerStats. HP * 1.2, delta * 4)
	$JP           .size.x = lerpf($JP           .size.x, PlayerStats.MJP * 1.2, delta * 7)
	$JP/Bar       .size.x = lerpf($JP/Bar       .size.x, PlayerStats. JP * 1.2, delta * 4)
	$JP           .position.x = 906 - $JP.size.x
	$JP/Bar       .position.x = $JP.size.x - $JP/Bar.size.x
	$Effect.text = "[center]"
	var h = 0
	var j = 0
	if not Engine.is_editor_hint():
		for e in PlayerStats.EFF.size():
			$Effect.text += "[color=#" + PlayerStats.EFF[e].color.to_html(false) + "]" + PlayerStats.EFF[e].name + "[/color]\n"
			$HP/Bar.get_child(e).size.x = lerpf($HP/Bar.get_child(e).size.x, PlayerStats.EFF[e].EHP * 1.2, delta * 2)
			$JP/Bar.get_child(e).size.x = lerpf($JP/Bar.get_child(e).size.x, PlayerStats.EFF[e].EJP * 1.2, delta * 2)
			h += $HP/Bar.get_child(e).size.x
			$HP/Bar.get_child(e).position.x = $HP/Bar.size.x - h
			$JP/Bar.get_child(e).position.x = j
			j += $JP/Bar.get_child(e).size.x
	$Effect.text += "[/center]"
	if LevelOfViolence - floor(LevelOfViolence) < 0.01:
		$LV.text = "LV " + "%d" % LevelOfViolence
	elif (LevelOfViolence * 10) - floor(LevelOfViolence * 10) < 0.1:
		$LV.text = "LV " + "%.1f" % LevelOfViolence
	else:
		$LV.text = "LV " + "%.2f" % LevelOfViolence
	$TextBox/Balloon/Rect.modulate = lerp(C, TC, T)
	if has_node("SKILL"): $SKILL.JP = PlayerStats.JP

func Pain():
	if get_parent() is Battle:
		get_parent().playerStats.HP /= 2
	else: PlayerStats.HP /= 2

func Fight():
	$Buttons/FIGHT.release_focus()
	for i in $Buttons.get_children(): i.disabled = true
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
	for i in $Buttons.get_children(): i.disabled = true
	$TextBox.hide()
	var A = Actiŋscn.instantiate()
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
	for i in $Buttons.get_children(): i.disabled = true
	$TextBox.hide()
	var S = Skillscn.instantiate()
	add_child(S, true)
	S.connect("nvm", func():
		playerTurn(S.get_node("ColorRect").DC)
		S.queue_free()
	)
	S.connect("skill", func(qhat, cost):
		emit_signal("Unskilledpoint", qhat, cost)
		C  = S.get_node("ColorRect").DC
		TC = S.get_node("ColorRect").DC
		if $TextBox.visible:
			await $TextBox.finished
			TC = Globals.Colors["DarkGreen"]
		emit_signal("YourTurn")
	)

#func Item():
#	$Buttons/ITEM.release_focus()
#	for i in $Buttons.get_children(): i.disabled = true

func Mercy():
	$Buttons/MERCY.release_focus()
	for i in $Buttons.get_children(): i.disabled = true
	$TextBox.hide()
	var M = Mercyscn.instantiate()
	add_child(M, true)
	M.connect("nvm", func():
		playerTurn(M.get_node("Rect").DC)
		M.queue_free()
	)
	M.connect("send", func(j):
		emit_signal("Spear", j)
		C  = M.get_node("Rect").DC
		TC = M.get_node("Rect").DC
		if $TextBox.visible:
			await $TextBox.finished
			TC = Globals.Colors["DarkGreen"]
		emit_signal("YourTurn")
	)

signal YourTurn()
signal Ask(enm, act)
signal Unskilledpoint(qhat, cost)
signal Spear(huh)
signal What()
