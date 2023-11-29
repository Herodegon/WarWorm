class_name Weapon_DualTurret

extends Node2D

const BODY_SEGMENT_SIZE = 32

var snake: Snake
var walls: Walls
var enemy_spawner: Enemy_Spawner
var bullet = preload("res://Scenes/weapons/bullet.tscn")
var bullets = []

# Base Weapon Stats
class Weapon_Properties:
	var damage: int
	var piercing: int
	var speed: int
	var size: int
	var duration: float
	
var weapon_properties = Weapon_Properties.new()
var body_index: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func setup(snake: Snake, walls: Walls, enemy_spawner: Enemy_Spawner):
	self.snake = snake
	self.walls = walls
	self.enemy_spawner = enemy_spawner
	
	set_weapon_properties()
	snake.on_fire_weapon.connect(on_fire_weapon)

func set_weapon_properties():
	
	weapon_properties.damage = 1
	weapon_properties.piercing = 1
	weapon_properties.speed = BODY_SEGMENT_SIZE/2
	weapon_properties.size = BODY_SEGMENT_SIZE/8
	weapon_properties.duration = 1.5

func on_fire_weapon():
	spawn_bullet()
	
func spawn_bullet():
	var bullet_velocity
	match rotation_degrees:
		270.0:
			bullet_velocity = Vector2(0,-weapon_properties.speed)
		90.0:
			bullet_velocity = Vector2(0,weapon_properties.speed)
		180.0:
			bullet_velocity = Vector2(-weapon_properties.speed,0)
		0.0:
			bullet_velocity = Vector2(weapon_properties.speed,0)
	
	var bullet_properties = weapon_properties
	var new_bullet = bullet.instantiate()
	new_bullet.setup(snake,walls,enemy_spawner)
	new_bullet.set_bullet_properties(bullet_properties,bullet_velocity)
	add_child(new_bullet)
