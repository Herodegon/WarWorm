class_name Walls

extends Node

var walls_dict = {}
var top_left_corner: Vector2
var top_right_corner: Vector2
var bottom_left_corner: Vector2
var bottom_right_corner: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	var walls = get_tree().get_nodes_in_group("group_walls") as Array[Node2D]
	for wall in walls:
		if wall.position.x < 0:
			walls_dict["left"] = wall
		elif wall.position.x > 0:
			walls_dict["right"] = wall
		elif wall.position.y < 0:
			walls_dict["top"] = wall
		elif wall.position.y > 0:
			walls_dict["bottom"] = wall
	
	top_left_corner = Vector2(walls_dict["left"].position.x, walls_dict["top"].position.y)
	print_debug(top_left_corner)
	top_right_corner = Vector2(walls_dict["right"].position.x, walls_dict["top"].position.y)
	print_debug(top_right_corner)
	bottom_left_corner = Vector2(walls_dict["left"].position.x, walls_dict["bottom"].position.y)
	print_debug(bottom_left_corner)
	bottom_right_corner = Vector2(walls_dict["right"].position.x, walls_dict["bottom"].position.y)
	print_debug(bottom_right_corner)
