@tool
extends Control
@export var PlayerStats     : Stats 
@export var EffectColors    : PackedColorArray = []
@export var StatusEffects   : PackedStringArray = []
@export var LevelOfViolence := 1
var EffectNum : int

func _ready():
	EffectNum = min(PlayerStats.EHP.size(),PlayerStats.EJP.size())
	$TextBox/Balloon.position.y += 300
	playerTurn()
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

func playerTurn():
	$Buttons/FIGHT.grab_focus()

func _process(delta):
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
	$TextBox/Balloon/Rect.modulate = Color.WHITE

func Fight():
	$Buttons/FIGHT.release_focus()
