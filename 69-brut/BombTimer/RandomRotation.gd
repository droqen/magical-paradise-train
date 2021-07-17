extends Sprite
export var change_rotation_on_time = 0.25
export var angle_range = 20
export var angle_offset = 0
var timer = 0


func _process(delta):
	timer += delta
	if(timer > change_rotation_on_time):
		timer = 0
		rotation_degrees = rand_range(-angle_range, angle_range) + angle_offset
