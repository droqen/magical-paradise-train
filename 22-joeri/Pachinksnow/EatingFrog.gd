extends "res://22-joeri/Pachinksnow/Frog.gd"

export (NodePath) var snowflake_to_eat

enum STATE {
	off,
	on,
	eating,
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
		
		var snowflake = get_node(self.snowflake_to_eat)
		if snowflake && (snowflake.current_state == snowflake.STATE.on || snowflake.current_state == snowflake.STATE.melting):
			self.current_state = STATE.eating
			snowflake.current_state = snowflake.STATE.being_eaten
	elif self.current_state == STATE.eating:
		var snowflake = get_node(self.snowflake_to_eat)
		snowflake.current_state = snowflake.STATE.being_eaten
		$AnimatedSprite.play("eat")
		yield($AnimatedSprite, "animation_finished")
		snowflake.current_state = snowflake.STATE.off
		$AnimatedSprite.play("eat", true)
		yield($AnimatedSprite, "animation_finished")
		self.current_state = STATE.on
