class_name Snake_Texture

extends TextureRect

var snake_spritesheet = preload("res://Assets/snake_spritesheet.png")

# Properties
var frames_per_row: int = 4  # Number of frames per row in your sprite sheet.
var frame_width: int = 36    # Width of each frame in pixels.
var frame_height: int = 36   # Height of each frame in pixels.
var current_frame: int = 0   # Current frame index.

# Function to set the frame based on the frame index.
func set_frame(frame_index: int):
	var columns = snake_spritesheet.get_width() / frame_width
	var row = int(frame_index / frames_per_row)
	var col = frame_index % frames_per_row
	var frame_rect = Rect2(col * frame_width, row * frame_height, frame_width, frame_height)
	self.texture = snake_spritesheet
	self.rect_position = frame_rect.position

# Called when the node enters the scene tree.
func _ready():
	set_frame(0)
