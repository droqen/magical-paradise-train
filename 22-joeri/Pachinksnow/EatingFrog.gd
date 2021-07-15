extends "res://22-joeri/Pachinksnow/Frog.gd"

enum STATE {
	booting_up,
	off,
	on,
	eating,
}

export (NodePath) var snowflake_to_eat
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
			eat(snowflake)

func eat(snowflake: Snowflake):
	self.current_state = STATE.eating	
	snowflake.eat()
	$AnimatedSprite.play("eat")
	yield($AnimatedSprite, "animation_finished")
	snowflake.turn_off()
	$AnimatedSprite.play("retract")
	yield($AnimatedSprite, "animation_finished")
	self.current_state = STATE.on

func boot_up():
	self.current_state = STATE.booting_up
	$AnimatedSprite.set_animation("eat")
	$AnimatedSprite.stop()
	$AnimatedSprite.set_frame(1)
	yield(self.get_tree().create_timer(0.5), "timeout")
	$AnimatedSprite.set_animation("turn_on")
	$AnimatedSprite.set_frame(0)
	self.current_state = STATE.off
