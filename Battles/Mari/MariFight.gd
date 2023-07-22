extends Node2D

var playerStats = Globals.PlayerStats.duplicate()
var attackNum = 0
var attacks = [
	preload("res://Battles/Mari/Mintro.tscn")
]

func _ready():
	$UI.PlayerStats = playerStats
	$UI.LevelOfViolence = Globals.LV
	
	var M = Enemy.new()
	var S = Stats.new()
	S.HP  = 100
	S.MHP = 100
	S.ATK = 4
	S.DEF = Globals.LV
	S.MAG = 7
	M.Name = "Mari"
	M.Check = "uh"
	M.Position = 456
	M.Scale = 0.8
	M.Stat = S
	Globals.Enemies = [M]

func _process(delta):
	playerStats.JP += delta / 5

func attack():
	attackNum += 1
	if attackNum == 1:
		var A = attacks[0].instantiate()
		add_child(A)
		await A.tree_exiting
	$UI.playerTurn()

func the_ouchies(intensity):
	Globals.Enemies[0].Stat.HP -= max(intensity * playerStats.ATK * 15 / Globals.Enemies[0].Stat.DEF, 0)
	Globals.Enemies[0].Stat.DEF = max(Globals.Enemies[0].Stat.DEF * 0.95, 1)
	$Label/ProgressBar.value = Globals.Enemies[0].Stat.HP
	$Label/ProgressBar.max_value = Globals.Enemies[0].Stat.MHP
	var LB = $Label.duplicate()
	$Damage.add_child(LB)
	LB.show()
	LB.text = "%d" % max(ceil(intensity * playerStats.ATK * 15 / Globals.Enemies[0].Stat.DEF), 0)
	var TW = create_tween()
	TW.tween_property(LB, "position", Vector2(400, 100), .3).set_trans(Tween.TRANS_CUBIC)
	TW.tween_property(LB, "position", Vector2(400, 170), .7).set_trans(Tween.TRANS_CUBIC)
	await TW.finished
	LB.queue_free()
	if Globals.Enemies[0].Stat.HP <= 0:
		pass
