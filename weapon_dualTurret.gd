class_name Weapon_DualTurret

extends Node2D

const BODY_SEGMENT_SIZE = 32

var snake: Snake
var walls: Walls
var enemy_spawner: Enemy_Spawner
@onready var bullet_nodes: Node = $bullet_nodes
var bullet = preload("res://Scenes/weapons/bullet.tscn")
var bullets = []

# Base Weapon Stats
class Weapon_Properties:
	var damage: int
	var piercing: int
	var speed: int
	var size: int
	var duration: float
	
var body_index: int

var weapon_properties = Weapon_Properties.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func setup(snake: Snake, walls: Walls, enemy_spawner: Enemy_Spawner):
	self.snake = snake
	self.walls = walls
	self.enemy_spawner = enemy_spawner
	
	weapon_properties = set_properties()
	
	snake.on_fire_weapon.connect(on_fire_weapon)

func set_properties(copy_list: Weapon_Properties = null):
	var properties_list = Weapon_Properties.new()
	if copy_list == null:
		properties_list.damage = 1
		properties_list.piercing = 1
		properties_list.speed = BODY_SEGMENT_SIZE/2
		properties_list.size = BODY_SEGMENT_SIZE/8
		properties_list.duration = 1.0
	else:
		properties_list.damage = copy_list.damage
		properties_list.piercing = copy_list.piercing
		properties_list.speed = copy_list.speed
		properties_list.size = copy_list.size
		properties_list.duration = copy_list.duration
	return properties_list

func on_fire_weapon():
	spawn_bullet()
	
func spawn_bullet():
	var bullet_velocity
	match self.rotation_degrees:
		270.0:
			bullet_velocity = Vector2(0,-weapon_properties.speed)
		90.0:
			bullet_velocity = Vector2(0,weapon_properties.speed)
		180.0:
			bullet_velocity = Vector2(-weapon_properties.speed,0)
		0.0:
			bullet_velocity = Vector2(weapon_properties.speed,0)
	
	var bullet_properties = set_properties(weapon_properties)
	var new_bullet = bullet.instantiate()
	new_bullet.setup(snake,walls,enemy_spawner)
	new_bullet.set_bullet_properties(bullet_properties,bullet_velocity)
	new_bullet.position = self.position + (bullet_velocity*weapon_properties.speed)/3
	bullet_nodes.add_child(new_bullet)
	bullets.append(new_bullet)
