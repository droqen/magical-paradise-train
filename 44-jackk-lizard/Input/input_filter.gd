extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var allow_input = true

func _input(_event):
	if !allow_input:
		get_tree().set_input_as_handled()

func _on_lizard_left_pushup_post():
	allow_input = false
	$SwipeUp.cleanup()
	$SwipeDown.cleanup()


func _on_lizard_ready_for_pushups():
	allow_input = true
	$SwipeUp.cleanup()
	$SwipeDown.cleanup()
