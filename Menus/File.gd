@tool
extends TextureButton

@export var filenum = 1

func _process(_delta):
	$"#".text    =         "File %d"        % filenum
	var filename = "user://SaveFile%d.omo1" % filenum
	var f    = FileAccess.open(filename, FileAccess.READ)
	for i in get_children():
		i.show()
	if f == null:
		for i in 4:
			get_child(i+1).hide()
		return
	var vc = f.get_16()
	if vc == 0x0800:
		var d = f.get_var(true)
		$N.text  = d[1]
		var xp   = d[2]
		var t    = int(d[3])
		var area = d[4]
		$T.text  = "%03d:%02d" % [(t-t%60)/60, t%60]
		$L.text  = "LV %d" % GLOBALS.LVfromXP(xp)
		$P.text  = area

func _on_pressed():
	Globals.SaveSlot = filenum
	if Globals.Fload(filenum):
		get_tree().change_scene_to_file("res://Menus/Namer.tscn")
	else:
		get_tree().change_scene_to_file("res://Menus/Hub.tscn")
