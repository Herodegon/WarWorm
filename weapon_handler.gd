class_name Weapon_Handler

extends Node

var weapon_dict = {
	"gun_turret": preload("res://Scenes/weapons/weapon_dualTurret.tscn")
}

@onready var snake: Snake = $"../snake"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func get_weapon(weapon_name):
	if !(weapon_dict.has(weapon_name)):
		return null
	else:
		return weapon_dict[weapon_name]
	
