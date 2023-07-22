@tool
@icon("res://Assets/Icons/SoulState.svg")

extends Resource
class_name SoulState

@export var Red := false :
	set(value):
		if Red != value:
			Red = value
			emit_changed()
@export var Orange := false :
	set(value):
		if Orange != value:
			Orange = value
			emit_changed()
@export var Yellow := false :
	set(value):
		if Yellow != value:
			Yellow = value
			emit_changed()
@export var Green := false :
	set(value):
		if Green != value:
			Green = value
			emit_changed()
@export var Mint := false :
	set(value):
		if Mint != value:
			Mint = value
			emit_changed()
@export var Teal := false :
	set(value):
		if Teal != value:
			Teal = value
			emit_changed()
@export var Blue := false :
	set(value):
		if Blue != value:
			Blue = value
			emit_changed()
@export var Purple := false :
	set(value):
		if Purple != value:
			Purple = value
			emit_changed()

@export var Value : int :
	set(val):
		if Value != val:
			Red = val & 1
			Orange = val & 2
			Yellow = val & 4
			Green = val & 8
			Mint = val & 16
			Teal = val & 32
			Blue = val & 64
			Purple = val & 128
			emit_changed()
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
