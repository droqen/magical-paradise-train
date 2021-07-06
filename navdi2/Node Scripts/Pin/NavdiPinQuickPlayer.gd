extends Node
class_name NavdiPinQuickPlayer

export(float,0,0.975)var dpad_deadzone = 0.5
var stick: Vector2
var dpad: Vector2
var dpad_impulse: Vector2
var a = PinSingle.new()
var b = PinSingle.new()
var up = PinSingle.new()
var down = PinSingle.new()
var left = PinSingle.new()
var right = PinSingle.new()

func process_pins(): # always call this right before reading
	stick = Vector2(
		Input.get_action_strength("right")-
		Input.get_action_strength("left"),
		Input.get_action_strength("down")-
		Input.get_action_strength("up")
	)
	a.process_key(Input.is_action_pressed("a"))
	b.process_key(Input.is_action_pressed("b"))
	right.process_key(stick.x > 0.9, stick.x < 0.1)
	left.process_key(-stick.x > 0.9, -stick.x < 0.1)
	down.process_key(stick.y > 0.9, stick.y < 0.1)
	up.process_key(-stick.y > 0.9, -stick.y < 0.1)
	dpad = Vector2(
		int(right.held)-
		int(left.held),
		int(down.held)-
		int(up.held)
	)
	dpad_impulse = Vector2(
		int(right.just_pressed)-
		int(left.just_pressed),
		int(down.just_pressed)-
		int(up.just_pressed)
	)

#func process_pin_strength_threshold(pinSingle:PinSingle, action_name:String, hold_thresh, release_thresh):
#	var s = Input.get_action_strength(action_name)
#	pinSingle.process_key(s >= hold_thresh, s <= release_thresh)

