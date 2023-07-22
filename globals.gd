extends Node

class_name GLOBALS #for constants, in ðe editor

enum Weapon {
	Stick, MkrPhone, __, Ruler, Sword, PntGun, IceSk8, Knife, RedKnife
}
enum Armor {
	Bandage, RlrSk8, PropHat, ChfHat, GstClk, FlwCrn, TrnCrn
}
const Colors = {
	"Red": Color("f00"),
	"Orange": Color("f90"),
	"Yellow": Color("ff0"),
	"Green": Color("0b0"),
	"Mint": Color("0f7"),
	"Cyan": Color("0cf"),
	"Teal": Color("09f"),
	"Blue": Color("03f"),
	"Purple": Color("b3d"),
	"DarkGreen": Color("090"),
	"DarkOrange": Color("840"),
	"DarkMint": Color("096"),
	"LightTeal": Color("8bf")
}
const areas = [
	"[???]",
	"Pinwheel Forest",
	"Otherworld Colony",
	"Lakeside Isles",
	"Snowglobe Peaks",
	"Faraway City"
]

# (WARNING) 
# 
# pLEASE don't look in ðis file, even I don't know what
# half of ðese variables do...
# k þx bye

var SaveSlot := -1
var FileOVERRIDE := ""
var KeyboardLayout = ""
var PlayerName = ""
var debugAttack = 0
var debugAnimation = "default"
var Secrets = 0
var Found = []
var EXP = 0 # 143143143143143143
var LV: int:
	get:
		return GLOBALS.LVfromXP(EXP)
var PlayerStats := Stats.new():
	get:
		PlayerStats.MHP = GLOBALS.MHPfromLV(LV)
		PlayerStats.MJP = GLOBALS.MJPfromLV(LV)
		PlayerStats.HP = PlayerStats.MHP
		PlayerStats.JP = 0
		PlayerStats.ATK = LV * 1.5
		PlayerStats.DEF = LV * 0.5
		PlayerStats.MAG = LV * .75
		return PlayerStats
var TIME = 0
var AREA = 0
var WEPN : Weapon = Weapon.Stick
var ARMR : Armor = Armor.Bandage
var Enemies : Array[Enemy] = []
var musynctime = 0.0
var skiptext := true

func _ready():
	var args = OS.get_cmdline_args()
	if args[0].ends_with(".omo1"):
		FileOVERRIDE = args[0]
		ld(args[0])
		get_tree().change_scene_to_file("res://Menus/Hub.tscn")

func _process(delta):
	TIME += delta

func Fsave(file:int):
	var filename = "user://SaveFile%d.omo1" % file if FileOVERRIDE == "" else FileOVERRIDE
	var f = FileAccess.open(filename, FileAccess.WRITE)
	f.store_var([KeyboardLayout, PlayerName, EXP, AREA, TIME], true)

func Fload(file:int):
	var filename = "user://SaveFile%d.omo1" % file if FileOVERRIDE == "" else FileOVERRIDE
	ld(filename)

func ld(filename):
	var f = FileAccess.open(filename, FileAccess.READ)
	if f == null:
		return true
	var d = f.get_var(true)
	KeyboardLayout = d[0]
	PlayerName     = d[1]
	EXP  = d[2]
	AREA = d[3]
	TIME = d[4]
	return false

static func LVfromXP(XP:int):
	if XP < 10:
		return 1
	if XP < 20:
		return 2
	if XP < 40:
		return 3
	if XP < 80:
		return 4
	if XP < 160:
		return 5
	if XP < 300:
		return 6
	if XP < 600:
		return 7
	if XP < 1200:
		return 8
	if XP < 2400:
		return 9
	if XP < 4800:
		return 10
	if XP < 10000:
		return 11
	if XP < 20000:
		return 12
	if XP < 40000:
		return 13
	if XP < 80000:
		return 14
	if XP < 120000:
		return 15
	if XP < 240000:
		return 16
	if XP < 480000:
		return 17
	if XP < 999999:
		return 18
	if XP < 1444443:
		return 19
	return 20

static func MHPfromLV(lv:int):
	if lv < 20:
		return lv * 6 + 20
	else:
		return lv * 9 - 37

static func MJPfromLV(lv:int):
	if lv < 20:
		return lv * 4 + 16
	else:
		return lv * 7 - 41
