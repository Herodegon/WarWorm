class_name Bullet

extends Node2D

@onready var snake: Snake = $"../snake"

var velocity: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	snake.timer.timeout.connect(on_bullet_timeout)
	
func on_bullet_timeout():
	pass
