@icon("res://Assets/Icons/Stats.svg")
extends Resource
class_name Stats

@export var  HP = 26.
@export var MHP = 26.
@export var EHP : Array[float] = []
@export var  JP = 0.
@export var MJP = 20.
@export var EJP : Array[float] = []
@export var ATK : float = 1
@export var DEF : float = 1
@export var MAG : float = 1

var IHP :
	get: return HP as int
var IJP :
	get: return JP as int
