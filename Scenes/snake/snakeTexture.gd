class_name SnakeTexture

extends TextureRect

const FRAMES_PER_ROW = 4
const DISTANCE_BETWEEN_FRAMES = 4 # Distance in pixels
const FRAME_WIDTH = 32 + DISTANCE_BETWEEN_FRAMES
const FRAME_HEIGHT = 32 + DISTANCE_BETWEEN_FRAMES
var current_frame: int = 0 # Current frame index
var total_frames: int = FRAMES_PER_ROW * ($snake_spritesheet.get_width() / FRAME_WIDTH)

func set_frame(frame_index: int):
	var columns = 
	var row = frame_index/FRAMES_PER_ROW
	var column = frame_index%FRAMES_PER_ROW
