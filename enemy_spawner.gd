class_name Enemy_Spawner

extends Node

const BODY_SEGMENT_SIZE = 32

var enemy_list = [
	preload("res://Scenes/enemies/enemy_walker.tscn")
]

@onready var spawn_timer = $spawn_timer
@onready var snake: Snake = $"../snake"
@onready var walls: Walls = $"../walls"

@onready var enemies_spawned: Node = $enemies_spawned
var enemies = []

var num_enemies_per_spawn: int = 1
var num_timeouts: int = 0

# Limits enemy types that can be spawned at a given time
var lower_range = 0
var upper_range = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_timer.timeout.connect(on_timeout)
	
func on_timeout():
	if num_timeouts%5 == 0:
		num_enemies_per_spawn += 1
	elif num_enemies_per_spawn%25 == 0:
		num_enemies_per_spawn += 2
	
	if upper_range > (enemy_list.size()-1):
		upper_range = enemy_list.size()-1
		
	for i in num_enemies_per_spawn:
		spawn_enemy()
		
	num_timeouts += 1
	
func spawn_enemy():
	var enemy_index = randi_range(lower_range,upper_range)
	var new_enemy = enemy_list[enemy_index].instantiate()
	new_enemy.setup(snake, walls)
	new_enemy.position = get_spawn_position()
	enemies_spawned.add_child(new_enemy)
	enemies.append(new_enemy)

func get_spawn_position():
	var rand_wall = randi_range(0, 3)
	var x_pos
	var y_pos
	match rand_wall:
		0: # Top Wall - POSITION OFF ON Y-AXIS
			x_pos = round(randi_range(walls.top_left_corner.x + BODY_SEGMENT_SIZE, walls.top_right_corner.x - BODY_SEGMENT_SIZE)/BODY_SEGMENT_SIZE)*BODY_SEGMENT_SIZE
			y_pos = walls.walls_dict["top"].position.y
		1: # Bottom Wall
			x_pos = round(randi_range(walls.bottom_left_corner.x + BODY_SEGMENT_SIZE, walls.bottom_right_corner.x - BODY_SEGMENT_SIZE)/BODY_SEGMENT_SIZE)*BODY_SEGMENT_SIZE
			y_pos = walls.walls_dict["bottom"].position.y
		2: # Left Wall - POSITION OFF ON X-AXIS
			x_pos = walls.walls_dict["left"].position.x
			y_pos = round(randi_range(walls.top_left_corner.y + BODY_SEGMENT_SIZE, walls.bottom_left_corner.y - BODY_SEGMENT_SIZE)/BODY_SEGMENT_SIZE)*BODY_SEGMENT_SIZE
		3: # Right Wall
			x_pos = walls.walls_dict["right"].position.x
			y_pos = round(randi_range(walls.top_right_corner.y + BODY_SEGMENT_SIZE, walls.bottom_right_corner.y - BODY_SEGMENT_SIZE)/BODY_SEGMENT_SIZE)*BODY_SEGMENT_SIZE
	if (x_pos != 0 && fmod(x_pos,BODY_SEGMENT_SIZE) != 0):
		var difference_x = fmod(x_pos,BODY_SEGMENT_SIZE)
		x_pos -= difference_x
	if (y_pos != 0 && fmod(y_pos,BODY_SEGMENT_SIZE) != 0):
		var difference_y = fmod(y_pos,BODY_SEGMENT_SIZE)
		y_pos -= difference_y
	return Vector2(x_pos,y_pos)
