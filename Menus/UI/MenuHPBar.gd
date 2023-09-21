extends ColorRect

func _process(delta):
	size.x = Globals.PlayerStats.HP / Globals.MHPfromLV(Globals.LV) * get_parent().size.x
