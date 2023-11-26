class_name Weapon_DualTurret

extends Node2D

const BODY_SEGMENT_SIZE = 32

@onready var snake: Snake = $"../snake"
@export var bullet: Bullet

var velocity = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	snake.on_fire_weapon.connect(on_fire_weapon)
	
func on_fire_weapon():
	spawn_bullet(move_direction)
	
func spawn_bullet():
	var new_bullet = bullet.instantiate()
	new_bullet.velocity = velocity
	add_child(new_bullet)
	
