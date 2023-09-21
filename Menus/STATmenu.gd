extends RichTextLabel

var TIME = 0

func _process(delta):
	TIME += delta
	text =  ("[color=#ff8080]ATK[/color]: %d\n" % Globals.PlayerStats.ATK) + \
			("[color=#80ff80]DEF[/color]: %d\n" % Globals.PlayerStats.DEF) + \
			("[color=#80ffff]MAG[/color]: %d\n" % Globals.PlayerStats.MAG) + \
			("[color=#ffff80]EXP[/color]: %d\n" % Globals.EXP) + \
			("[color=#ffb880]Next LV[/color]: %d\n" % \
			(GLOBALS.minEXPfromLV(Globals.LV + 1) - Globals.EXP)) + \
			"Weapon: %s\nArmor: %s" % \
			[GLOBALS.WeaponNames[Globals.WEPN], GLOBALS.ArmorNames[Globals.ARMR]]
