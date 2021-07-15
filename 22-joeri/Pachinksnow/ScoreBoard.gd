extends Node2D

enum STATE {
	booting_up,
	off,
	on,
}

export var maximum = 0
var current_state = STATE.off
var current_score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	if self.current_state == STATE.off:
		$Label/LabelSnowflake.set_frame(0)
		$Label/LabelFront.hide()
	elif self.current_state == STATE.on:
		$Label/LabelSnowflake.set_frame(1)
		$Label/LabelFront.show()

func boot_up():
	self.current_state = STATE.booting_up
	$Label/LabelSnowflake.set_frame(1)
	$Label/LabelFront.show()
	yield(self.get_tree().create_timer(0.5), "timeout")
	$Label/LabelSnowflake.set_frame(0)
	$Label/LabelFront.hide()
	self.current_state = STATE.off

func set_current_score(score: int):
	self.current_score = score
	var index = 0
	for snowflake in $SnowCounter.get_children():
		if index + 1 > current_score:
			snowflake.set_frame(0)
		else:
			snowflake.set_frame(1)
		index += 1

func set_maximum(maximum: int):
	var new_label = create_label(maximum)
	$Label/LabelFront.text = new_label
	$Label/LabelShadow.text = new_label

func create_label(maximum: int):
	return 'catch ' + str(maximum)
