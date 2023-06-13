extends Node2D

var uhname = ""

func _ready():
	var row = 0
	for l in Globals.KeyboardLayout:
		if l == "\n":
			row += 1
		else:
			var b = $_.duplicate(5)
			b.name = l
			b.text = l
			if l == "←":
				b.text = "<-"
				b.connect("pressed", remove_letter)
			elif l == "*":
				b.text = "OK"
				b.connect("pressed", finished)
			else:
				b.connect("pressed", add_letter.bind(l))
			$kb.get_child(row).add_child(b)
	$kb/r1.get_child(0).grab_focus()

func _process(delta):
	$"the uh name".text = "[shake rate=10 level=1][center]\n" + uhname

func add_letter(l):
	if uhname.length() < 7:
		uhname += l

func remove_letter():
	if uhname.length() > 0:
		uhname = uhname.substr(0, uhname.length()-1)

func finished():
	if uhname.length() > 0:
		Globals.PlayerName = uhname
		Globals.Fsave(Globals.SaveSlot)
		get_tree().change_scene_to_file("res://Menus/Hub.tscn")
