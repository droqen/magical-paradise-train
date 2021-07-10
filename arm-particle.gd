extends Node2D


var rotation_speed = 1
var target_point = Vector2(0,0)

var start_point = Vector2(100,100)
var start_rotation = 0

var start_time

const DURATION = .4

var modulation

# Called when the node enters the scene tree for the first time.
func _ready():
	start_time = OS.get_ticks_msec()
	global_position = start_point
	rotation = start_rotation
	$Sprite.modulate = modulation


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var now = OS.get_ticks_msec()
	
	rotation += rotation_speed*delta
	
	var target = get_parent().get_node("Line2D").global_position
	#target = target_point
	
	global_position += (target - start_point) * delta
	
	var s = scale.x - delta
	scale = Vector2(s,s)
	
	if s < .1:
		queue_free()
