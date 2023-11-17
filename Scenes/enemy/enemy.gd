class_name enemy_walker

extends Node2D

const BODY_SEGMENT_SIZE = 32

@onready var snake: Snake = $"../snake"

var move_direction = Vector2.ZERO

func _ready():
	position = Vector2(128.0,128.0)
	snake.timer.timeout.connect(walker_timeout)

func walker_timeout():
	get_move_direction()
	
	var new_position = position + (move_direction*BODY_SEGMENT_SIZE)
	var enemy_snake_collision = check_enemy_snake_collision(new_position)
	if enemy_snake_collision:
		snake.on_damage()
	position = new_position
	
func get_move_direction():
	for part in snake.body_parts:
		if part.position.x == position.x:
			if part.position.y > position.y:
				move_direction = Vector2.DOWN
				break
			elif part.position.y <= position.y:
				move_direction = Vector2.UP
				break
		elif part.position.y == position.y:
			if part.position.x > position.x:
				move_direction = Vector2.RIGHT
				break
			elif part.position.y <= position.y:
				move_direction = Vector2.LEFT
				break
				
func check_enemy_snake_collision(new_enemy_position: Vector2):
	for part in snake.body_parts:
		if part.position == position:
			return true
			
	return false
