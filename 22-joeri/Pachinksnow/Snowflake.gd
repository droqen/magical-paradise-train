extends Node2D

class_name Snowflake

export (Array, NodePath) var next_snowflakes = []

signal melted

enum STATE {
	booting_up,
	off,
	on,
	melting,
	being_eaten,
}

var current_state
var state_timer = 0

func _ready():
	turn_off()

func _process(_delta):
	if self.current_state == STATE.off:
		$AnimatedSprite.stop()
		$AnimatedSprite.set_frame(0)
	elif self.current_state == STATE.on:
		$AnimatedSprite.stop()
		$AnimatedSprite.set_frame(1)
	elif self.current_state == STATE.melting:
		$AnimatedSprite.play()
	elif self.current_state == STATE.being_eaten:
		$AnimatedSprite.stop()
		$AnimatedSprite.set_frame(1)

func turn_on():
	self.current_state = STATE.on	
	$MeltTimer.stop()

	$OnTimer.start()
	yield($OnTimer, "timeout")
	if next_snowflakes.size() == 0:
		self.melt()
		emit_signal('melted')
	else:
		var next_snowflake = get_node(next_snowflakes[randi() % next_snowflakes.size()])
		next_snowflake.turn_on()
		self.turn_off()

func boot_up():
	self.current_state = STATE.booting_up
	$AnimatedSprite.set_frame(1)
	yield(self.get_tree().create_timer(0.5), "timeout")
	$AnimatedSprite.set_frame(0)
	self.turn_off()

func turn_off():
	self.current_state = STATE.off
	$OnTimer.stop()
	$MeltTimer.stop()

func melt():
	self.current_state = STATE.melting
	$OnTimer.stop()

	$MeltTimer.start()
	yield($MeltTimer, "timeout")
	self.turn_off()

func eat():
	self.current_state = STATE.being_eaten
	$OnTimer.stop()
	$MeltTimer.stop()
