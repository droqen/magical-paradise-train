extends "res://22-joeri/Pachinksnow/Frog.gd"

enum STATE {
	booting_up,
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

func boot_up():
	self.current_state = STATE.booting_up
	$AnimatedSprite.set_animation("turn_on")
	$AnimatedSprite.stop()
	$AnimatedSprite.set_frame(1)
	yield(self.get_tree().create_timer(0.5), "timeout")
	$AnimatedSprite.set_frame(0)
	self.current_state = STATE.off
