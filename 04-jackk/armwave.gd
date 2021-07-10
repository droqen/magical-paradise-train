extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal rot_changed(delta)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_NavdiCursorFollower_cursor_updated():
	var cursor_pos = get_parent().get_node("NavdiCursorFollower").cursor_position
	var new_rot = -PI/6 + (cursor_pos.x/90.0 * PI/2)
	new_rot = min(PI/2*1.1,new_rot)
	new_rot = max(PI/2/9,new_rot)
	var rot_delta = new_rot - rotation
	if abs(rot_delta) > 0.0001:
		rotation = new_rot
		emit_signal("rot_changed", rot_delta)
	
