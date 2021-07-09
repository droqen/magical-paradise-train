extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal arm_moved

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_world_rect():
	var extents = ($Area2D/CollisionShape2D.shape as RectangleShape2D).get_extents()
	var arr = PoolVector2Array()
	arr.push_back(Vector2(-extents.x, -extents.y))
	arr.push_back(Vector2( extents.x, -extents.y))
	arr.push_back(Vector2( extents.x,  extents.y))
	arr.push_back(Vector2(-extents.x,  extents.y))
	arr = global_transform.xform(arr)
	return arr

func _on_NavdiCursorFollower_cursor_updated():
	var cursor_pos = get_parent().get_node("NavdiCursorFollower").cursor_position
	
	cursor_pos.x += 20
	
	var diff = cursor_pos - global_position
	
	var glare_scale = get_parent().get_node("sun/glare").scale.x
	var scaler = (glare_scale-.6)/2
	scaler = min(1,scaler)
	scaler = max(0,scaler)
	diff.x *= scaler
	diff.y *= scaler
	
	#if cursor_pos.y < 0:
	#	var yscale = -cursor_pos.y/10
	#	yscale = min(1,yscale)
	#	diff.y *= (1-yscale)
		
	global_position += diff
	
	emit_signal("arm_moved")
	
	
