tool
extends Node
class_name NavdiPinSetup

enum PinPreset{
	GodotDefault,
	ArrowsWSAD,
	Handmadedeathlabyrinth,
	Tragedymasocore,
}

export(PinPreset)var preset = PinPreset.ArrowsWSAD
export(bool)var tool_start_device0_vib
export(bool)var tool_stop_device0_vib

func _ready():
	if not Engine.editor_hint:
		match preset:
			PinPreset.GodotDefault:
				pass
			PinPreset.ArrowsWSAD:
				_add_action_span("left", [KEY_LEFT, KEY_A], [14], [[JOY_AXIS_0, -1]])
				_add_action_span("right", [KEY_RIGHT, KEY_D], [15], [[JOY_AXIS_0, 1]])
				_add_action_span("up", [KEY_UP, KEY_W], [12], [[JOY_AXIS_1, -1]])
				_add_action_span("down", [KEY_DOWN, KEY_S], [13], [[JOY_AXIS_1, 1]])
				_add_action_span("a", [KEY_SPACE, KEY_Z, KEY_ENTER], [0])
				_add_action_span("b", [KEY_ESCAPE, KEY_X, KEY_BACKSPACE], [1])
			PinPreset.Handmadedeathlabyrinth:
				_add_action_span("left", [KEY_LEFT, KEY_A], [14], [[JOY_AXIS_0, -1]])
				_add_action_span("right", [KEY_RIGHT, KEY_D], [15], [[JOY_AXIS_0, 1]])
				_add_action_span("up", [KEY_UP, KEY_W], [12], [[JOY_AXIS_1, -1]])
				_add_action_span("down", [KEY_DOWN, KEY_S], [13], [[JOY_AXIS_1, 1]])
				_add_action_span("a", [KEY_SPACE, KEY_Z, KEY_X, KEY_ENTER], [0])
				_add_action_span("b", [KEY_TAB, KEY_C, KEY_SHIFT], [1])
			PinPreset.Tragedymasocore:
				_add_action_span("left", [KEY_LEFT, #KEY_A
				], [14], [[JOY_AXIS_0, -1]])
				_add_action_span("right", [KEY_RIGHT, #KEY_D
				], [15], [[JOY_AXIS_0, 1]])
				_add_action_span("up", [KEY_UP, #KEY_W
				], [12], [[JOY_AXIS_1, -1]])
				_add_action_span("down", [KEY_DOWN, #KEY_S
				], [13], [[JOY_AXIS_1, 1]])
				_add_action_span("a", [KEY_SPACE, KEY_Z, KEY_X, KEY_ENTER], [0])
				_add_action_span("b", [KEY_ESCAPE, KEY_TAB], [1])
#		queue_free()
			
func _process(_delta):
	if Engine.editor_hint:
		if tool_start_device0_vib:
			tool_start_device0_vib = false
			Input.start_joy_vibration(0, 1, 1, 1)
		if tool_stop_device0_vib:
			tool_stop_device0_vib = false
			Input.stop_joy_vibration(0)
#		if click_to_apply:
#			click_to_apply = false
#			match preset:
#				PinPreset.GodotDefault:
#					pass
#				PinPreset.ArrowsWSAD:
#					_add_action_span("left", [KEY_LEFT, KEY_A], [14], [[JOY_AXIS_0, -1]])
#					_add_action_span("right", [KEY_RIGHT, KEY_D], [15], [[JOY_AXIS_0, 1]])
#					_add_action_span("up", [KEY_UP, KEY_W], [12], [[JOY_AXIS_1, -1]])
#					_add_action_span("down", [KEY_DOWN, KEY_S], [13], [[JOY_AXIS_1, 1]])

func _add_action_span(action_name, keys=[], butts=[], axes=[]):
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)
	for key_scancode in keys:
		var event = InputEventKey.new()
		event.set_scancode(key_scancode)
		InputMap.action_add_event(action_name, event)
	for butt in butts:
		var event:InputEventJoypadButton = InputEventJoypadButton.new()
		event.device = 0
		event.button_index = butt
		InputMap.action_add_event(action_name, event)
	for axis_data in axes:
		var event:InputEventJoypadMotion = InputEventJoypadMotion.new()
		event.device = 0
		event.axis = axis_data[0]
		event.axis_value = axis_data[1]
		InputMap.action_add_event(action_name, event)
	
	
	
	
