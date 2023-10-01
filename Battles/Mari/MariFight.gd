extends Battle

func _on_start():
	var M = Enemy.new()
	var S = Stats.new()
	S.HP  = 100
	S.MHP = 100
	S.ATK = 4
	S.DEF = 1 + Globals.LV / 1.5
	S.MAG = 7
	M.Name = "Mari"
	M.Check = "uh"
	M.Position = $EHbox.position.x - 32
	M.Scale = 0.8
	M.Stat = S
	M.ACTs = [
		"Check", "Talk"
	]
	Globals.Enemies = [M]
	$UI.DialogueSource = "res://Dialogue/marifight.dialogue"
	attacks = [
		load("res://Battles/Mari/Mintro.tscn"),
		load("res://Battles/Mari/Windtro.tscn"),
		load("res://Battles/Mari/Two.tscn")
	]

func _on_frame(_delta):
	pass

func get_dialogue_title():
	return "FlTxt0"

func choose_attack():
	if attackNum == 1: return 0
	elif attackNum == 2: return 1
	else: return 2

func act(enemy, action):
	if enemy != "Mari": return
	match action:
		"Check":
			$UI.DialogueText = "Check"
			$UI.dialogue()
