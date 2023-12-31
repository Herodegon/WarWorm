class_name Enemy_Walker

extends Node2D

const BODY_SEGMENT_SIZE = 32

var snake: Snake
var walls: Walls
var walls_dict

@onready var health_label: Label = $health_label
@onready var health_timer: Timer = $health_label/health_timer

var top_left_corner: Vector2
var bottom_right_corner: Vector2

var move_direction = Vector2.ZERO
var enemy_timeout: int = 2 # Number of times snake moves before enemy moves

var maxHealth: int = 2
var currHealth: int = maxHealth
var damage: int = 1 

func _ready():
	pass
	
func setup(snake: Snake, walls: Walls):
	self.snake = snake
	self.walls = walls
	snake.timer.timeout.connect(walker_timeout)
	
	walls_dict = walls.walls_dict

# Main Enemy AI
func walker_timeout():
	var new_position = position
	top_left_corner = position
	bottom_right_corner = position + Vector2(BODY_SEGMENT_SIZE,BODY_SEGMENT_SIZE)
	if enemy_timeout == 0:
		get_move_direction()
		new_position += (move_direction*BODY_SEGMENT_SIZE)
		enemy_timeout = 2
		
		# Snake Collision
		var enemy_snake_collision = check_enemy_snake_collision(new_position)
		if enemy_snake_collision:
			snake.on_damage(damage)
		
	# Wall Collision
	var enemy_wall_collision = check_enemy_wall_collision(new_position)
	if enemy_wall_collision == null:
		position = new_position
	else:
		var position_after_collision = get_enemy_pos_after_wall_collision(enemy_wall_collision, new_position)
		new_position = position_after_collision
		position = new_position
	
	enemy_timeout -= 1
	
func get_move_direction():
	for part in snake.body_parts:
		if part.position.x == position.x:
			if part.position.y > position.y:
				move_direction = Vector2.DOWN
				return
			elif part.position.y <= position.y:
				move_direction = Vector2.UP
				return
		elif part.position.y == position.y:
			if part.position.x > position.x:
				move_direction = Vector2.RIGHT
				return
			elif part.position.y <= position.y:
				move_direction = Vector2.LEFT
				return
				
	if snake.position.y != position.y && (move_direction != Vector2.DOWN && move_direction != Vector2.UP):
		if snake.position.y > position.y:
			move_direction = Vector2.DOWN
		elif snake.position.y < position.y:
			move_direction = Vector2.UP
	elif snake.position.x != position.x && (move_direction != Vector2.RIGHT && move_direction != Vector2.LEFT):
		if snake.position.x > position.x:
			move_direction = Vector2.RIGHT
		elif snake.position.x < position.x:
			move_direction = Vector2.LEFT

func on_damage(damage_dealt: int):
	currHealth -= damage_dealt
	if currHealth <= 0:
		health_label.visible = false
		self.queue_free()
	else:
		health_label.text = "%d/%d" % [currHealth,maxHealth]
		health_label.visible = true
		health_timer.start()

func check_enemy_wall_collision(new_enemy_position: Vector2):
	if new_enemy_position.x <= walls_dict["left"].position.x && move_direction == Vector2.LEFT:
		return snake.collisionDirection.LEFT
	elif new_enemy_position.x >= walls_dict["right"].position.x && move_direction == Vector2.RIGHT:
		return snake.collisionDirection.RIGHT
	elif new_enemy_position.y <= walls_dict["top"].position.y && move_direction == Vector2.UP:
		return snake.collisionDirection.TOP
	elif new_enemy_position.y >= walls_dict["bottom"].position.y && move_direction == Vector2.DOWN:
		return snake.collisionDirection.BOTTOM
		
func get_enemy_pos_after_wall_collision(wall_collision, new_enemy_position: Vector2):
	if (wall_collision == snake.collisionDirection.LEFT || wall_collision == snake.collisionDirection.RIGHT) && new_enemy_position.y <= 0:
		move_direction = Vector2.DOWN
	elif (wall_collision == snake.collisionDirection.LEFT || wall_collision == snake.collisionDirection.RIGHT) && new_enemy_position.y > 0:
		move_direction = Vector2.UP
	elif (wall_collision == snake.collisionDirection.TOP || wall_collision == snake.collisionDirection.BOTTOM) && new_enemy_position.x <= 0:
		move_direction = Vector2.RIGHT
	elif (wall_collision == snake.collisionDirection.TOP || wall_collision == snake.collisionDirection.BOTTOM) && new_enemy_position.x > 0:
		move_direction = Vector2.LEFT
		
	return (position + move_direction*BODY_SEGMENT_SIZE)
				
func check_enemy_snake_collision(new_enemy_position: Vector2):
	for part in snake.body_parts:
		if new_enemy_position == part.position:
			return true
	return false
