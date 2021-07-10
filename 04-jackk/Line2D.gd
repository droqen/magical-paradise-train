extends Line2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var t = 0

func _on_NavdiCursorFollower_cursor_updated():
	var cursor_pos = get_parent().get_node("NavdiCursorFollower").cursor_position
	var sun_ratio = get_parent().get_node("sun").overlap_ratio
	
	#var a = 30 + cursor_pos.y
	#var b = 60 + cursor_pos.x
	#var t = (a+b)/5000.0
	t += randf()/5
	#var r = int(a+b) % 40 + 30
	var r = 70
	var weird_position = Vector2(80+r*sin(t), 80+r*cos(t))
	var good_pos = Vector2(120,85)
	
	global_position = weird_position.linear_interpolate(good_pos, sun_ratio)
