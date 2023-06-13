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
	var d = f.get_var(true)
	$N.text  = d[1]
	var xp   = d[2]
	var area = d[3]
	var t    = int(d[4])
	$T.text  = "%03d:%02d" % [(t-t%60)/60, t%60]
	$L.text  = "LV %d" % Globals.LVfromXP(xp)
	$P.text  = Globals.areas[area]

func _on_pressed():
	Globals.SaveSlot = filenum
	if Globals.Fload(filenum):
		get_tree().change_scene_to_file("res://Menus/Namer.tscn")
	else:
		get_tree().change_scene_to_file("res://Menus/Hub.tscn")
