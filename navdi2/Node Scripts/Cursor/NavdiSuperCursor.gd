tool
extends Node
class_name NavdiSuperCursor

enum CursorInputMode {
	None,
	JoypadOrKeyboard,
	Mouse,
}

signal any_position_moved(pos, move)
signal idle_position_moved(pos, move)
signal held_position_moved(pos, move)

export(float)var joypad_time_to_cross_view = 2.00
export(float)var joypad_time_to_full_speed = 0.10
export(bool)var mouse_locked = false
export(float)var mouse_locked_sens = 300.0
export(Vector2)var mouse_offset = Vector2(-1,-3)
export(CursorInputMode)var input_mode = CursorInputMode.None
export(Array, CursorInputMode)var disabled_input_modes = [CursorInputMode.JoypadOrKeyboard,]
export(bool)var pin_enabled = false

var _joypad_position: Vector2 = Vector2.ZERO
var _joypad_velocity: Vector2 = Vector2.ZERO
var _joypad_button: bool = false

var button_release_buffer: int = 0
var raw_buttonheld: bool
var raw_mouse_pos: Vector2

var any_mouse_pos setget set_any_mouse_pos, get_any_mouse_pos
var idle_mouse_pos setget set_idle_mouse_pos, get_idle_mouse_pos
var held_mouse_pos setget set_held_mouse_pos, get_held_mouse_pos

var _any_mouse_pos_tracker = MousePosTracker.new(self, "any_position_moved")
var _idle_mouse_pos_tracker = MousePosTracker.new(self, "idle_position_moved")
var _held_mouse_pos_tracker = MousePosTracker.new(self, "held_position_moved")

func _input(event):
	if event is InputEventMouse:
		if input_mode != CursorInputMode.Mouse:
			if get_viewport().get_visible_rect().has_point(event.position) and not event.button_mask&1:
				set_input_mode(CursorInputMode.Mouse)
			else:
				return # ignore mouse input
		_update_cursor(event.button_mask&1, event.position + mouse_offset)

func _physics_process(delta):
	if Engine.editor_hint: return
	
	if pin_enabled:
		var pin: NavdiPinQuickPlayer
		if has_node("NavdiPinQuickPlayer"):
			pin = $NavdiPinQuickPlayer
		else:
			pin = NavdiPinQuickPlayer.new()
			pin.name = "NavdiPinQuickPlayer"
			add_child(pin)
			pin.set_owner(owner if owner else self)
			push_warning("NavdiSuperCursor doesn't have a NavdiPinQuickPlayer, so it spawned one.")
		pin.process_pins()
		
		_joypad_button = pin.a.held
		_joypad_position = pin.stick
		
		if _joypad_position or _joypad_button:
			set_input_mode(CursorInputMode.JoypadOrKeyboard)
		
		if input_mode == CursorInputMode.JoypadOrKeyboard:
			var joypad_speed = 300.0
			if joypad_time_to_cross_view > .001:
				joypad_speed = max(get_viewport().size.x, get_viewport().size.y
				) / joypad_time_to_cross_view
			if joypad_time_to_full_speed > .001:
				var target_velocity = _joypad_position.clamped(1) * joypad_speed
				_joypad_velocity += (target_velocity - _joypad_velocity
				).clamped(delta * joypad_speed / joypad_time_to_full_speed)
			else:
				_joypad_velocity = _joypad_position.clamped(1) * joypad_speed
			
			if self.any_mouse_pos == null or not get_viewport().get_visible_rect().has_point(self.any_mouse_pos):
				_update_cursor(_joypad_button,
				get_viewport().size * 0.5 + delta * _joypad_velocity)
			else:
				_update_cursor(_joypad_button,
				self.any_mouse_pos + delta * _joypad_velocity)

func refresh():
	_update_cursor(raw_buttonheld, raw_mouse_pos)

func _update_cursor(buttonheld, pos):
	if Engine.editor_hint: return # skip
	if raw_buttonheld and not buttonheld and button_release_buffer < 2:
		button_release_buffer += 1
	else:
		button_release_buffer = 0
		raw_buttonheld = buttonheld
	raw_mouse_pos = pos
	set_any_mouse_pos(pos)
	if raw_buttonheld:
		if self.held_mouse_pos == null:
			set_idle_mouse_pos(pos)
		set_held_mouse_pos(pos)
	else:
		set_idle_mouse_pos(pos)
		set_held_mouse_pos(null)

func get_any_mouse_pos():
	return _any_mouse_pos_tracker.current_pos
func get_idle_mouse_pos():
	return _idle_mouse_pos_tracker.current_pos
func get_held_mouse_pos():
	return _held_mouse_pos_tracker.current_pos

func set_any_mouse_pos(pos):
	_any_mouse_pos_tracker.set_pos(pos)
func set_idle_mouse_pos(pos):
	_idle_mouse_pos_tracker.set_pos(pos)
func set_held_mouse_pos(pos):
	_held_mouse_pos_tracker.set_pos(pos)

func set_input_mode(mode):
	if mode in disabled_input_modes:
		return
	
	input_mode = mode
	if Engine.editor_hint:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else: match input_mode:
		CursorInputMode.Mouse:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		_:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func clear_input_mode():
	input_mode = CursorInputMode.None
	set_any_mouse_pos(null)
	set_idle_mouse_pos(null)
	set_held_mouse_pos(null)

class MousePosTracker:
	var _super_cursor
	var _moved_signal
	var current_pos
	func _init(super_cursor, my_pm_signal_name):
		self._super_cursor = super_cursor
		self._moved_signal = my_pm_signal_name
		self.current_pos = null
	func set_pos(pos):
		if pos is Vector2:
			for lobe in _super_cursor.get_children():
				if lobe.has_method('modify_cursor_pos'):
					pos = lobe.modify_cursor_pos(pos)
		
		if current_pos != pos:
			if pos == null:
				_super_cursor.emit_signal(_moved_signal, null, current_pos)
				 # the 'move' var here indicates pos upon release
				current_pos = null
			else:
				var move = Vector2.ZERO
				if current_pos != null: move = current_pos - pos
				_super_cursor.emit_signal(_moved_signal, pos, move)
				current_pos = pos
