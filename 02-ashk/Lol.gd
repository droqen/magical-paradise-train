extends Node2D
var elapsed_time = 0.0

func _ready():
	pass # Replace with function body.

func _process(delta):
	elapsed_time += delta
	$Text.rect_rotation = sin(elapsed_time)
	pass
