@tool
@icon("res://Assets/Icons/SoulState.svg")

extends Resource
class_name SoulState

@export var Red := false
@export var Orange := false
@export var Yellow := false
@export var Green := false
@export var Mint := false
@export var Teal := false
@export var Blue := false
@export var Purple := false

@export var Value : int :
	set(val):
		Red = val & 1
		Orange = val & 2
		Yellow = val & 4
		Green = val & 8
		Mint = val & 16
		Teal = val & 32
		Blue = val & 64
		Purple = val & 128
	get:
		return int(Purple) * 128 + int(Blue) * 64 + int(Teal) * 32 + int(Mint) * 16 + \
		int(Green) * 8 + int(Yellow) * 4 + int(Orange) * 2 + int(Red)

const RED := 1
const ORANGE := 2
const YELLOW := 4
const GREEN := 8
const MINT := 16
const TEAL := 32
const BLUE := 64
const PURPLE := 128
