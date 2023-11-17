class_name CurrFrame

extends TextureRect

@onready var snakeFrames: $snakeFrames

const DISTANCE_BETWEEN_FRAMES = 4
const FRAME_WIDTH = 32 + DISTANCE_BETWEEN_FRAMES
const FRAME_HEIGHT = 32 + DISTANCE_BETWEEN_FRAMES

# Called when the node enters the scene tree for the first time.
func _ready():
	get_frame(0)
	
func get_frame(frame_index: int):
	snakeFrames.set()
