extends Node


var jumpPressedLastFrame

#weird work around to not use godot actions
func _ready():
	pass # Replace with function body.

func GetJumpInput() -> bool:
	return Input.is_action_just_pressed("ui_accept")
	
func GetJumpReleaseInput():
	return Input.is_action_just_released("ui_accept")
	
func GetDirectionalInputs() -> Vector2:
	#returns a vector2 of directional inputs
	#up/down and left/right will cancel each other out
	#up is negative y, down is positive y
	#uses arrow keys and wasd
	
	var inputVec : Vector2 = Vector2.ZERO
	
	var up    = Input.is_key_pressed(KEY_UP) || Input.is_key_pressed(KEY_W)
	var down  = Input.is_key_pressed(KEY_DOWN) || Input.is_key_pressed(KEY_S)
	var left  = Input.is_key_pressed(KEY_LEFT) || Input.is_key_pressed(KEY_A)
	var right  = Input.is_key_pressed(KEY_RIGHT) || Input.is_key_pressed(KEY_D)
	
	if up    : inputVec.y += -1
	if down  : inputVec.y +=  1
	if left  : inputVec.x += -1
	if right : inputVec.x +=  1
	
	return inputVec
	

	
	
	
	
