class_name PinSingle

var just_released: bool = false
var just_pressed: bool = false
var released: bool = false
var held: bool = false
func _init():
	pass
func process_key(down, up=null):
	just_pressed = false
	just_released = false
	if down:
		if released:
			released = false
			just_pressed = true
		held = true
	elif up==null:
		up = true
	
	if up:
		if not released:
			released = true
			just_released = true
		held = false
