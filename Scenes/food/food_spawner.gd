class_name Food_Spawner

extends Node

const BODY_SEGMENT_SIZE = 32

@onready var walls: Walls = $"../walls"
@export var food_scene: PackedScene

@onready var food_spawned: Node = $food_spawned

var new_food: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_food()

func spawn_food():
	new_food = food_scene.instantiate()
	var x_pos = round(randi_range(walls.top_left_corner.x + BODY_SEGMENT_SIZE, walls.bottom_right_corner.x - BODY_SEGMENT_SIZE)/BODY_SEGMENT_SIZE)*BODY_SEGMENT_SIZE
	var y_pos = round(randi_range(walls.top_left_corner.y + BODY_SEGMENT_SIZE, walls.bottom_right_corner.y - BODY_SEGMENT_SIZE)/BODY_SEGMENT_SIZE)*BODY_SEGMENT_SIZE
	var food_position = Vector2(x_pos,y_pos)
	new_food.position = food_position
	food_spawned.add_child(new_food)

func destory_food(food_position):
	for food in food_spawned.get_children():
		if food != null && food.position == food_position:
			food.queue_free()
