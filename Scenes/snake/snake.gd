class_name Snake

extends Node2D

const BODY_SEGMENT_SIZE = 32

signal on_point_scored(points: int)
signal on_pause
signal on_game_over
signal on_fire_weapon

enum collisionDirection 
{
	TOP,
	BOTTOM,
	LEFT,
	RIGHT
}

var body_parts = []
var weapons = []
@onready var snake_parts: Node = $snake_parts
@onready var weapon_parts: Node = $weapon_parts
@onready var timer: Timer = $"../game_timer"
@onready var health_label: Label = $health_label
@onready var health_timer: Timer = $health_label/health_timer

var head_texture = preload("res://Assets/head.png")
var body_texture = preload("res://Assets/snake.png")
var dead_texture = preload("res://Assets/head_game-over.png")

@onready var food_spawner: Food_Spawner = $"../food_spawner"
@onready var enemy_spawner: Enemy_Spawner = $"../enemy_spawner"
@onready var weapon_handler: Weapon_Handler = $"../weapon_handler"
@onready var walls: Walls = $"../walls"
var walls_dict # Set on ready

# Direction of snake's next position
var move_direction = Vector2.ZERO
var can_input = true

var total_points = 0
var health = 3

func _ready():
	# Setup Snake Head
	var head = Sprite2D.new()
	head.position = Vector2(0,0)
	head.scale = Vector2(1,1)
	head.z_index = 2
	head.texture = head_texture
	snake_parts.add_child(head)
	body_parts.append(head)
	# Setup the timer
	timer.timeout.connect(on_timeout)
	food_spawner = get_tree().get_first_node_in_group("group_food_spawner")
	
	walls_dict = walls.walls_dict

func _input(event):
	if event is InputEventKey and event.pressed and can_input:
		# Movement
		if (event.is_action_pressed("ui_up") or event.is_action_pressed("up")) and move_direction.y != 1:
			move_direction = Vector2.UP
		elif (event.is_action_pressed("ui_down") or event.is_action_pressed("down")) and move_direction.y != -1:
			move_direction = Vector2.DOWN
		elif (event.is_action_pressed("ui_right") or event.is_action_pressed("right")) and move_direction.x != -1:
			move_direction = Vector2.RIGHT
		elif (event.is_action_pressed("ui_left") or event.is_action_pressed("left")) and move_direction.x != 1:
			move_direction = Vector2.LEFT
			
		# Fire Weapon(s)
		if event.is_action_pressed("fire"):
			on_fire_weapon.emit()
			
	# Pause
	if event is InputEventKey and event.pressed:
		if event.pressed and event.is_action_pressed("pause"):
			on_pause.emit()
			can_input = !(can_input)

# Main Snake Function
func on_timeout():
	var new_head_position = position + (move_direction*BODY_SEGMENT_SIZE)
	
	if health_timer.is_stopped():
		health_label.visible = false
		health_timer.wait_time = 2
	
	# Snake Collision
	var snake_collision = check_snake_collision(new_head_position)
	if snake_collision:
		on_damage()
	
	# Wall collision
	var wall_collision = check_wall_collision(new_head_position)
	if wall_collision == null:
		move_to_position(new_head_position)
	else:
		var position_after_collision = get_pos_after_wall_collision(wall_collision, new_head_position)
		new_head_position = position_after_collision
		move_to_position(position_after_collision)
	
	# Food Collision
	for food in food_spawner.get_children():
		if new_head_position == food.position:
			total_points += 1
			on_point_scored.emit(total_points)
			food_spawner.destory_food(food.position)
			food_spawner.spawn_food()
			add_body_part()
			
			if body_parts.size()%2 == 0:
				print_debug("Call to make weapon...")
				add_weapon_part("gun_turret", body_parts.size()-1)

func move_to_position(new_position):
	# Update Body - FIFO Implementation
	if body_parts.size() > 1:
		var last_element = body_parts.pop_back()
		last_element.position = body_parts[0].position
		last_element.rotation_degrees = update_sprite_rotation()
		body_parts.insert(1, last_element)
	
	# Update Head
	position = new_position
	body_parts[0].position = new_position
	body_parts[0].rotation_degrees = update_sprite_rotation()
	
	# Update Weapons
	move_weapon_positions()
	
func move_weapon_positions():
	if body_parts.size() > 1:
		for weapon in weapons:
			weapon.position = body_parts[weapon.body_index].position
			weapon.rotation_degrees = body_parts[weapon.body_index].rotation_degrees

func on_damage():
	health -= 1
	if health == 0:
		health_label.visible = false
		body_parts[0].texture = dead_texture
		on_game_over.emit()
		timer.stop()
	else:
		health_label.text = "%d/3" % health
		health_label.visible = true
		health_timer.start()
	
func check_wall_collision(new_head_position: Vector2):
	if new_head_position.x <= walls_dict["left"].position.x && move_direction == Vector2.LEFT:
		return collisionDirection.LEFT
	elif new_head_position.x >= walls_dict["right"].position.x && move_direction == Vector2.RIGHT:
		return collisionDirection.RIGHT
	elif new_head_position.y <= walls_dict["top"].position.y && move_direction == Vector2.UP:
		return collisionDirection.TOP
	elif new_head_position.y >= walls_dict["bottom"].position.y && move_direction == Vector2.DOWN:
		return collisionDirection.BOTTOM
		
func get_pos_after_wall_collision(wall_collision: collisionDirection, new_head_position: Vector2):
	if (wall_collision == collisionDirection.LEFT || wall_collision == collisionDirection.RIGHT) && new_head_position.y <= 0:
		move_direction = Vector2.DOWN
	elif (wall_collision == collisionDirection.LEFT || wall_collision == collisionDirection.RIGHT) && new_head_position.y > 0:
		move_direction = Vector2.UP
	elif (wall_collision == collisionDirection.TOP || wall_collision == collisionDirection.BOTTOM) && new_head_position.x <= 0:
		move_direction = Vector2.RIGHT
	elif (wall_collision == collisionDirection.TOP || wall_collision == collisionDirection.BOTTOM) && new_head_position.x > 0:
		move_direction = Vector2.LEFT
		
	return body_parts[0].position + move_direction*BODY_SEGMENT_SIZE
	
func check_snake_collision(new_head_position: Vector2):
	var body_parts_without_head = body_parts.slice(1, body_parts.size())
	if body_parts_without_head.filter(func(part): return part.position == new_head_position):
		return true
	return false

func add_body_part():
	var new_part = Sprite2D.new()
	new_part.scale = Vector2(body_parts[0].scale.x,body_parts[0].scale.y-0.1)
	new_part.position = body_parts[-1].position - (move_direction*BODY_SEGMENT_SIZE)
	new_part.texture = body_texture
	new_part.rotation = update_sprite_rotation()
	snake_parts.add_child(new_part)
	body_parts.append(new_part)
	
func add_weapon_part(weapon_name,body_index):
	var weapon_class = weapon_handler.get_weapon(weapon_name)
	print_debug(weapon_class.get_class())
	if weapon_class == null:
		print_debug("ERROR: Failed to make weapon")
	if weapon_class != null:
		var new_weapon = weapon_class.instantiate()
		print_debug("Weapon created")
		new_weapon.setup(self,walls,enemy_spawner)
		new_weapon.body_index = body_index
		weapon_parts.add_child(new_weapon)
		weapons.append(new_weapon)
		print_debug("Weapon attached")

# Returns sprite direction in degrees
func update_sprite_rotation():
	if move_direction == Vector2.UP:
		return 270.0
	elif move_direction == Vector2.DOWN:
		return 90.0
	elif move_direction == Vector2.LEFT:
		return 180.0
	else:
		return 0.0
