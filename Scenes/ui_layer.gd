class_name UI_Layer

extends CanvasLayer

@onready var buttonContainer: HBoxContainer

#Main UI
@onready var restart_button = $boxContainer/restart
@onready var quit_button = $boxContainer/quit
@onready var points_label = $points_label
@onready var pause_label = $pause_label
@onready var game_over_label = $game_over_label

@onready var snake: Snake = $"../snake"
@onready var enemy_spawner: Enemy_Spawner = $"../enemy_spawner"

var is_paused = false
var is_game_over = false

# Called when the node enters the scene tree for the first time.
func _ready():
	buttonContainer = get_node("boxContainer")
	snake.on_point_scored.connect(on_point_scored)
	snake.on_pause.connect(on_pause)
	snake.on_game_over.connect(on_game_over)
	restart_button.pressed.connect(on_restart_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)

func on_point_scored(points: int):
	points_label.text = "Points: %d" % points

func on_pause():
	if is_game_over: # If on Game Over screen, does not pause
		return
	is_paused = !(is_paused)
	match is_paused:
		true:
			snake.timer.set_paused(true)
			enemy_spawner.spawn_timer.set_paused(true)
			pause_label.visible = true
			buttonContainer.visible = true 
		false:
			snake.timer.set_paused(false)
			enemy_spawner.spawn_timer.set_paused(false)
			pause_label.visible = false

func on_game_over():
	is_game_over = true
	enemy_spawner.spawn_timer.stop()
	buttonContainer.visible = true
	game_over_label.visible = true
	
func on_restart_button_pressed():
	get_tree().reload_current_scene()
	
func on_quit_button_pressed():
	get_tree().quit()
