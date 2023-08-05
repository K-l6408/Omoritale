extends Battle

func _on_start():
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
	M.ACTs = [
		"Check", "Talk"
	]
	Globals.Enemies = [M]
	$UI.DialogueSource = "res://Dialogue/marifight.dialogue"
	attacks = [
		load("res://Battles/Mari/Mintro.tscn"),
		load("res://Battles/Mari/Two.tscn")
	]

func _on_frame(_delta):
	pass

func get_dialogue_title():
	return "FlTxt0"

func choose_attack():
	if attackNum == 1: return 0
	else: return 1

func act(enemy, action):
	if enemy != "Mari": return
	match action:
		"Check":
			$UI.DialogueText = "Check"
			$UI.dialogue()
