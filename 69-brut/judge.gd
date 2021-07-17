extends Sprite


var target_x = 1
var target_y = 1
var scale_speed = 5

onready var actual_scale = scale.x

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	target_y = 1/target_x
	target_x = lerp(target_x, 1*actual_scale, scale_speed*delta)
	scale = Vector2(target_x, target_y)

	if(Input.is_action_just_pressed("ui_select")):
		target_x = 0.5
