class_name Bullet

extends Node2D

var speed: float
var velocity: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _draw():
	check_enemies()
	new_position += round(velocity*speed)
	
func check_enemies():
	for enemy in enemy_spawner.get_children():
		
		
