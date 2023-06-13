extends Node

var SaveSlot := -1
var FileOVERRIDE := ""
var KeyboardLayout = ""
var PlayerName = ""
var debugAttack = 0
var debugAnimation = "default"
var Secrets = 0
var Found = []
var EXP = 0 #143143143143143143
var LV : int :
	get:
		return LVfromXP(EXP)
var TIME = 0
var AREA = 0
var wpn = 0
var arm = 0
var musynctime = 0.0
var skiptext := true
var Colors = {
	"Red": Color("f00"),
	"Orange": Color("f90"),
	"Yellow": Color("ff0"),
	"Green": Color("0b0"),
	"Mint": Color("0f7"),
	"Cyan": Color("0cf"),
	"Teal": Color("06f"),
	"Blue": Color("03f"),
	"Purple": Color("b3d"),
	"DarkGreen": Color("090"),
	"DarkOrange": Color("840"),
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

func LVfromXP(XP:int):
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

func MHPfromLV(lv:int):
	if lv < 20:
		return lv * 6 + 20
	else:
		return lv * 9 - 37
