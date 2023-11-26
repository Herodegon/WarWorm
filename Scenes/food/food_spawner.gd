class_name Food_Spawner

extends Node

const BODY_SEGMENT_SIZE = 32

@onready var walls: Walls = $"../walls"
@export var food_scene: PackedScene

var new_food: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 5:
		spawn_food()

func spawn_food():
	new_food = food_scene.instantiate()
	var x_pos = round(randi_range(walls.top_left_corner.x + BODY_SEGMENT_SIZE, walls.bottom_right_corner.x - BODY_SEGMENT_SIZE)/BODY_SEGMENT_SIZE)*BODY_SEGMENT_SIZE
	var y_pos = round(randi_range(walls.top_left_corner.y + BODY_SEGMENT_SIZE, walls.bottom_right_corner.y - BODY_SEGMENT_SIZE)/BODY_SEGMENT_SIZE)*BODY_SEGMENT_SIZE
	var food_position = Vector2(x_pos,y_pos)
	new_food.position = food_position
	add_child(new_food)

func destory_food(food_position):
	for food in get_children():
		if food != null && food.position == food_position:
			food.queue_free()
