extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(Curve)var scale_curve

signal scale_changed(scale)

onready var arm = get_parent().get_node("arm")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_world_polygon():
	var arr = PoolVector2Array()
	var r = $Area2D/CollisionShape2D.shape.radius
	for i in range(20):
		var x = cos(i/20.0*2*PI)*r
		var y = sin(i/20.0*2*PI)*r
		arr.push_back(Vector2(x,y))
	arr = global_transform.xform(arr)
	return arr

func triangle_area(a, b, c):
	var base = a-b
	var perp = Vector2(-base.y, base.x).normalized()
	var up = c-b
	var dot = up.x*perp.x + up.y*perp.y
	var vert = perp*dot
	
	return base.length() * vert.length() / 2	

func compute_overlap_area():
	var rect_world = arm.get_world_rect()
	var circle_world = get_world_polygon()
	
	var intersection_polygons = Geometry.intersect_polygons_2d(rect_world, circle_world)
	
	if (intersection_polygons.size() == 0):
		return 0
	var poly = intersection_polygons[0]
		
	var triangles = Geometry.triangulate_polygon(poly)
	var area = 0
	for i in range(0, triangles.size(), 3):
		area += triangle_area(poly[triangles[i]], poly[triangles[i+1]], poly[triangles[i+2]])
	return area
	
func compute_shortest_distance():
	var rect_world = arm.get_world_rect()
	var sun_pos = global_position
	var closest = 10000
	for i in range(4):
		var c = Geometry.get_closest_point_to_segment_2d(sun_pos, rect_world[i], rect_world[(i+1)%4])
		var dist = (sun_pos - c).length()
		closest = min(dist,closest)

	return closest	

func get_sun_area():
	var r = $Area2D/CollisionShape2D.shape.radius * scale.x
	return PI*r*r

func _on_NavdiCursorFollower_cursor_updated():
	var cursor_pos = get_parent().get_node("NavdiCursorFollower").cursor_position
	
	var t = cursor_pos.x / 60.0 + cursor_pos.y / 100
	var rot = t
	rotation = rot

const MIN_IDLE_SCALE = 2.5
func _on_arm_arm_moved():
	var overlap_area = compute_overlap_area()
	var sun_area = get_sun_area()
	
	var ratio = overlap_area / sun_area
	
	if overlap_area == 0:
		var dist = compute_shortest_distance()
		ratio = dist / 180.0
		ratio = min(ratio, 1)
		var scale = MIN_IDLE_SCALE+ratio
		$glare.scale = Vector2(scale,scale)
	else :
		var scale = scale_curve.interpolate(ratio*ratio)
		$glare.scale = Vector2(scale,scale)
		
	emit_signal("scale_changed", $glare.scale.x)
