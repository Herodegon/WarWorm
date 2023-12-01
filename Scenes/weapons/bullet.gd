class_name Bullet

extends Node2D

const BODY_SEGMENT_SIZE = 32

var snake: Snake
var walls: Walls
var enemy_spawner: Enemy_Spawner
var walls_dict

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
	
	walls_dict = walls.walls_dict
	
func set_bullet_properties(bullet_properties, bullet_velocity: Vector2):
	self.bullet_properties = bullet_properties
	self.bullet_velocity = bullet_velocity

func on_timeout():
	var new_position = position + bullet_velocity
	var enemy_collided_with = get_enemy_collided(new_position)
	if enemy_collided_with != null:
		enemy_collided_with.on_damage(bullet_properties.damage)
		bullet_properties.piercing -= 1
		
	self.position = new_position
	
	time_bullet_has_existed += bullet_timer.wait_time
	var is_despawn = check_bullet_death()
	if is_despawn:
		self.queue_free()
			
func get_enemy_collided(new_position):
	for enemy in enemy_spawner.enemies_spawned.get_children():
		if (
			(self.position.x >= enemy.position.x-BODY_SEGMENT_SIZE && self.position.x <= enemy.position.x+BODY_SEGMENT_SIZE)
			&& (self.position.y >= enemy.position.y-BODY_SEGMENT_SIZE && self.position.y <= enemy.position.y+BODY_SEGMENT_SIZE)
		):
			return enemy

func check_bullet_death():
	if (
		bullet_properties.piercing <= 0
		|| time_bullet_has_existed >= bullet_properties.duration
		|| check_if_wall_collision() == true
	):
		return true
	else:
		return false
		
func check_if_wall_collision():
	if (
		self.position.x <= walls_dict["left"].position.x
		|| self.position.x >= walls_dict["right"].position.x
		|| self.position.y <= walls_dict["top"].position.y
		|| self.position.y >= walls_dict["bottom"].position.y
	):
		return true
	else:
		return false
