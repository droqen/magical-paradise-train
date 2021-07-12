extends "res://22-joeri/Pachinksnow/Frog.gd"

enum STATE {
	off,
	on,
}

export (STATE) var current_state = STATE.off

func _ready():
	if (left_frog):
		left_frog = get_node(left_frog)
	if (right_frog):
		right_frog = get_node(right_frog)

func _process(_delta):
	if self.current_state == STATE.off:
		$AnimatedSprite.set_animation("turn_on")
		$AnimatedSprite.stop()
		$AnimatedSprite.set_frame(0)
	elif self.current_state == STATE.on:
		$AnimatedSprite.set_animation("turn_on")
		$AnimatedSprite.stop()
		$AnimatedSprite.set_frame(1)
