@icon("res://Assets/Icons/Stats.svg")
extends Resource
class_name Stats

enum Weapon {
	Stick, Rock, Sword, X, Knife, Y
}
enum Armor {
	Bandage, W, Eyepatch, X, Y, Z
}

@export var  HP = 26
@export var MHP = 26
@export var EHP : Array[int] = []
@export var  JP = 16
@export var MJP = 16
@export var EJP : Array[int] = []
@export var ATK = 0
@export var DEF = 0
@export var MAG = 1
@export var WPN : Weapon
@export var ARM : Armor
