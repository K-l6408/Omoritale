extends Node2D

class_name Battle

var playerStats = Globals.PlayerStats.duplicate()
var attackNum = 0
var attacks = []

func _ready():
	$UI.PlayerStats = playerStats
	$UI.LevelOfViolence = Globals.LV
	_on_start()
	$UI.DialogueText = get_dialogue_title()
	$UI.playerTurn(Color.WHITE)

func _on_start():
	pass

func _process(delta):
	playerStats.JP += delta / 5
	if playerStats.JP > playerStats.MJP: playerStats.JP = playerStats.MJP

func choose_attack() -> int:
	return 0

func attack():
	attackNum += 1
	var A = attacks[choose_attack()].instantiate()
	add_child(A)
	A.connect("hit", gothit)
	await A.tree_exiting
	$UI.DialogueText = get_dialogue_title()
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
	LB.text = "%d" % max(ceil(intensity * playerStats.ATK * 15 / Globals.Enemies[0].Stat.DEF), 0)
	var TW = create_tween()
	TW.tween_property(LB, "position", Vector2(400, 100), .3).set_trans(Tween.TRANS_CUBIC)
	TW.tween_property(LB, "position", Vector2(400, 170), .7).set_trans(Tween.TRANS_CUBIC)
	await TW.finished
	LB.queue_free()
	if Globals.Enemies[which].Stat.HP <= 0:
		emit_signal("enemydeath", which)

func gothit(what):
	if what is int:
		playerStats.HP -= what
	elif what is String:
		for i in Globals.Enemies:
			if i.Name == what:
				playerStats.HP -= i.Stat.ATK / playerStats.DEF

func Act(_enm, _act):
	act(_enm, _act)
	$UI.emit_signal("What")

func act(_enm, _act):
	pass

signal enemydeath(which)
