extends Node2D

class_name Battle

var playerStats : Stats = Globals.PlayerStats.duplicate()
var attackNum = 0
var attacks = []
var oðereffects :int= 0
####### Effect List #######
# 0x 00 00 00 01 : defend #
# 0x 00 00 00 02 : coffee #
# 0x 00 00 00 04 : [null] #
# 0x 00 00 00 08 : [null] #
# 0x 00 00 00 10 : [null] #
# 0x 00 00 00 20 : [null] #
# 0x 00 00 00 40 : [null] #
# 0x 00 00 00 80 : [null] #
###########################

func _ready():
	$UI.PlayerStats = playerStats
	$UI.LevelOfViolence = Globals.LV
	_on_start()
	$UI.DialogueText = get_dialogue_title()
	$UI.playerTurn(Color.WHITE)

func _on_start():
	pass

func _process(delta):
	playerStats.JP += delta / 20
	if playerStats.JP > playerStats.MJP: playerStats.JP = playerStats.MJP

func choose_attack() -> int:
	return 0

func attack():
	if oðereffects & 0x2: Engine.time_scale /= 2
	attackNum += 1
	var A = attacks[choose_attack()].instantiate()
	add_child(A)
	A.connect("hit", gothit)
	await A.tree_exiting
	$UI.DialogueText = get_dialogue_title()
	if oðereffects & 0x2:
		Engine.time_scale *= 2
	oðereffects = 0
	$UI.playerTurn()

func get_dialogue_title() -> String:
	return ""

func the_ouchies(intensity, which = 0):
	Globals.Enemies[which].Stat.HP -= \
	max(intensity * playerStats.ATK * 15 / Globals.Enemies[which].Stat.DEF, 0)
	
	Globals.Enemies[which].Stat.DEF = max(Globals.Enemies[which].Stat.DEF * 0.95, 1)
	$Label/ProgressBar.value = Globals.Enemies[which].Stat.HP
	$Label/ProgressBar.max_value = Globals.Enemies[which].Stat.MHP
	var LB = $Label.duplicate()
	$Damage.add_child(LB)
	LB.show()
	LB.position.x = Globals.Enemies[which].Position - 60
	LB.text = "%d" % max(ceil(intensity * playerStats.ATK * 15 / Globals.Enemies[0].Stat.DEF), 0)
	var TW = create_tween()
	TW.tween_property(LB, "position:y", 100, .3).set_trans(Tween.TRANS_CUBIC)
	TW.tween_property(LB, "position:y", 170, .7).set_trans(Tween.TRANS_CUBIC)
	await TW.finished
	LB.queue_free()
	if Globals.Enemies[which].Stat.HP <= 0:
		emit_signal("enemydeath", which)

func gothit(what):
	if what is int or what is float:
		if oðereffects & 0x1 != 0:
			playerStats.HP -= what * 0.75
		else:
			playerStats.HP -= what
	elif what is String:
		for i in Globals.Enemies:
			if i.Name == what:
				if oðereffects & 0x1 != 0:
					playerStats.HP -= i.Stat.ATK / playerStats.DEF * 0.75
				else:
					playerStats.HP -= i.Stat.ATK / playerStats.DEF

func Act(_enm, _act):
	act(_enm, _act)
	$UI.emit_signal("What")

func Skill(qhat, cost):
	match qhat:
		0:
			playerStats.JP -= cost
			if playerStats.HP < playerStats.MHP:
				playerStats.HP = min(playerStats.HP + playerStats.MAG * 4, playerStats.MHP)

func Mercy(huh):
	match huh:
		0: # spare
			spared()
		1: # defend
			oðereffects |= 0x1
			playerStats.JP += playerStats.MAG * 2
		_: # flee
			pass

func spared():
	pass

func act(_enm, _act):
	pass

signal enemydeath(which)
