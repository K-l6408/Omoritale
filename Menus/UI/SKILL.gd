extends Control

const SKILL_NAMES = [
	"Heal"
]
const SKILL_DESCS = [
	"[color=lightgreen]Heals[/color] some HP. Cost: [color=cyan]2 JP[/color]."
]
@onready var GRID = $ColorRect/GridContainer
var available : PackedByteArray = [0, 0, 0, 0, 0, 0]
var time = 0

func _ready():
	$ColorRect/Desc.hide()
	GRID.hide()

func _process(delta):
	if time < 1:
		time += delta * 3
		$ColorRect.E[0].y = lerp(170, 150, min(time, 1))
		if time >= 1:
			$ColorRect/Desc.show()
			GRID.show()
			loadskills()
			GRID.get_child(0).grab_focus()
	else:
		var FO = get_viewport().gui_get_focus_owner()
		if FO in GRID.get_children():
			$ColorRect/Desc.text = SKILL_DESCS[FO.wha]
	if Input.is_action_just_pressed("ui_cancel"): emit_signal("nvm")

func loadskills():
	for i in available.size():
		var LB : Button = $ColorRect/Template.duplicate()
		LB.show()
		LB.text = "   " + SKILL_NAMES[available[i]]
		LB.wha = available[i]
		GRID.add_child(LB)
		if i % 3 == 2:
			LB.focus_neighbor_right = GRID.get_child(i-2).get_path()
			GRID.get_child(i-2).focus_neighbor_left  = LB.get_path()
		if available.size()/3 == i/3:
			LB.focus_neighbor_bottom = GRID.get_child(i%3).get_path()
			GRID.get_child(i%3).focus_neighbor_top    = LB.get_path()

func button_press(whar):
	emit_signal("skill", whar)

signal nvm()
signal skill(qhat)
