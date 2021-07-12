extends Node2D

export (Array, NodePath) var next_snowflakes = []

signal melted

enum STATE {
	off,
	on,
	melting,
	being_eaten,
}

var current_state = STATE.off
var state_timer = 0;

func _process(_delta):
	if self.current_state == STATE.off:
		$AnimatedSprite.stop()
		$AnimatedSprite.set_frame(0)
	elif self.current_state == STATE.on:
		$AnimatedSprite.stop()
		$AnimatedSprite.set_frame(1)

		if $OnTimer.is_stopped():
			$OnTimer.start()
			yield($OnTimer, "timeout")
			$OnTimer.stop()
			_on_leave_state_on()
	elif self.current_state == STATE.melting:
		$AnimatedSprite.play()

		if $MeltTimer.is_stopped():
			$MeltTimer.start()
			yield($MeltTimer, "timeout")
			$MeltTimer.stop()
			self.current_state = STATE.off
	elif self.current_state == STATE.being_eaten:
		$AnimatedSprite.stop()
		$AnimatedSprite.set_frame(1)

func _on_leave_state_on():
	if next_snowflakes.size() == 0:
		self.current_state = STATE.melting
		emit_signal('melted')
	else:
		var next_snowflake = get_node(next_snowflakes[randi() % next_snowflakes.size()])
		next_snowflake.current_state = STATE.on
		self.current_state = STATE.off
