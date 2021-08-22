extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal lizard_win

# Called when the node enters the scene tree for the first time.
func _ready():
	$lizard.dest_position = $bush_point.global_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_state_machine_do_kick():
	#get_tree().paused = true
	#yield(get_tree().create_timer(.1), "timeout")
	#get_tree().paused = false
	pass


func do_win():
	yield(get_tree().create_timer(3), "timeout")
	emit_signal("lizard_win")
