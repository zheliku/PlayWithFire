extends Camera2D

class_name CameraController

var origin_pos: Vector2 = Vector2.ZERO

var _shake_frames: int = 0
var _shake_a: float = 8.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	origin_pos = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _shake_frames > 0:
		_shake_frames -= 1
		var offset := Vector2(randf_range(-_shake_a, _shake_a), randf_range(-_shake_a, _shake_a))
		position = origin_pos + offset
	else:
		position = origin_pos

func shake(frames: int, a: float = 8.0) -> void:
	_shake_frames = frames
	_shake_a = a