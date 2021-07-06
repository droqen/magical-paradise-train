tool
extends Sprite
class_name NavdiBitsySprite
export(Array, int
) var _frames = [0,1]
export var _rate: float = 5
var ani = 0

var frames: Array setget set_frames, get_frames
var rate: float setget set_rate, get_rate

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if texture:
		ani = fmod(ani + delta * _rate, len(_frames))
		frame = _frames[int(ani)]

func set_frames(__frames: Array):
	_frames = __frames
	ani = fmod(ani, len(_frames))
	frame = _frames[int(ani)]

func get_frames() -> Array:
	return _frames

func set_rate(__rate: float):
	_rate = __rate
	set_process(_rate > 0)

func get_rate() -> float:
	return _rate
