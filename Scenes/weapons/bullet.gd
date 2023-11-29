class_name Bullet

extends Node2D

var snake: Snake
var walls: Walls
var enemy_spawner: Enemy_Spawner

@onready var bullet_timer: Timer = $bullet_timer

var bullet_properties
var bullet_velocity
var time_bullet_has_existed = float(0.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	bullet_timer.timeout.connect(on_timeout)
	
func setup(snake: Snake, walls: Walls, enemy_spawner: Enemy_Spawner):
	self.snake = snake
	self.walls = walls
	self.enemy_spawner = enemy_spawner
	
func set_bullet_properties(bullet_properties, bullet_velocity: Vector2):
	self.bullet_properties = bullet_properties
	self.bullet_velocity = bullet_velocity

func on_timeout():
	var new_position = position + bullet_velocity
#	var enemy_collided = check_enemy_collision()
#	if enemy_collided != null:
#		enemy_collided.on_damage()
#		bullet_properties.piercing -= 1
	position = new_position
	
	time_bullet_has_existed += bullet_timer.wait_time
	var is_despawn = check_bullet_death()
	if is_despawn:
		queue_free()
	
# func check_enemy_collision():
#	for enemy in enemy_spawner.get_children():
#		if enemy.position == self.position:
#			return enemy
			
func check_bullet_death():
	if bullet_properties.piercing <= 0:
		return true
	elif time_bullet_has_existed >= bullet_properties.duration:
		return true
	else:
		return false
