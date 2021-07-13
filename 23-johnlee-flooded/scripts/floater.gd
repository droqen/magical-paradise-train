extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(float) var accel
export(float) var deAccel
export(float) var maxSpeed
export(bool) var rat
var velocity = Vector2()
var fan
# Called when the node enters the scene tree for the first time.
func _ready():
	fan = get_parent().get_node("NavdiCursorFollower") 
	pass # Replace with function body.

#other things to factor in: how close you r 2 fan, 
#how close the angle is to fan front (fan will just rotate to face center of screen)
func _physics_process(delta):
	if Input.is_action_pressed("left mouse button"):
		velocity+= ((position-fan.position).normalized()*accel)*delta
		if velocity.length() >maxSpeed:
			 velocity=velocity.normalized()*maxSpeed
	else:
		velocity= velocity.move_toward(Vector2(0,0),deAccel*delta)
	velocity=move_and_slide(velocity)
	pass
