extends Node2D

export var door_count = 10

var doors = []
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var loop_time = 0.0
var big_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var the_original = $CutawayTrainCar
	for i in range(door_count - 1):
		var the_copy = the_original.duplicate()
		add_child(the_copy)
	doors = get_children()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	loop_time += delta
	big_time += delta
	loop_time = wrapf(loop_time, 0.0, 1.0)
	for i in range(door_count):
		doors[i].z_index = i
		doors[i].position = lerp(Vector2(300.0,-50.0), Vector2(100.0, 50.0), (i + loop_time)/(door_count + 1.0) )
		doors[i].modulate = Color.from_hsv(wrapf(loop_time*0.3 + i * 0.3, 0.0, 1.0), 0.2, (i + loop_time)/(door_count + 1.0) )
		doors[i].scale = Vector2.ONE * pow(2.0, lerp(-2.0, 2, (i + loop_time)/(door_count + 1.0) ) )
		var door_lerp = -3.5 + 10.0 * (i + loop_time)/(door_count + 1.0)
		door_lerp = clamp(door_lerp, 0.0, 1.0)
		doors[i].get_child(0).position.x = lerp(45, 225, smoothstep(45, 225, lerp(45, 225, door_lerp)))
		doors[i].get_child(1).position.x = lerp(-102, -265, smoothstep(-102, -265, lerp(-102, -265, door_lerp)))
	
	
	
	
	pass
