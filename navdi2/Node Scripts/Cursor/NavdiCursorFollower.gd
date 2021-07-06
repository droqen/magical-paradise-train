extends Node2D
class_name NavdiCursorFollower

signal cursor_updated()

enum CursorMode {
	AnyCursor = 0,
	IdleCursor = 1,
	HeldCursor = 2,
}

export(String)var get_cursor_from_group = ""
export(NodePath)var path_to_cursor = ""
export(CursorMode)var cursor_mode = CursorMode.AnyCursor
export(bool)var round_position = true
export(bool)var stay_when_released = false
#export(Rect2)var bounding_rect:Rect2 = Rect2(-1000,-1000,2000,2000)

var _cursor = null
var _viewer: NavdiViewerWindow = null

var cursor_position = null
var pressed = false
var just_pressed = false
var just_released = false

func _ready():
	hide()
	
	if _cursor == null and get_cursor_from_group:
		var group_cursors = get_tree().get_nodes_in_group(get_cursor_from_group)
		if group_cursors:
			_cursor = group_cursors[0]
		else:
			push_warning("NavdiCursorFollower %s could not find a cursor in group %s" % [name, get_cursor_from_group])
	
	if _cursor == null and path_to_cursor:
		if has_node(path_to_cursor):
			_cursor = get_node(path_to_cursor)
		else:
			push_warning("NavdiCursorFollower %s could not find a cursor at path %s" % [name, path_to_cursor])
	
	if _cursor == null:
		push_warning("NavdiCursorFollower %s could not find a cursor" % [name])
		return
	
	print("NavdiCursorFollower %s has _cursor %s" % [name, _cursor.name])
	
	match cursor_mode:
		CursorMode.AnyCursor:
			_cursor.connect("any_position_moved", self, "_on_cursor_moved")
		CursorMode.IdleCursor:
			_cursor.connect("idle_position_moved", self, "_on_cursor_moved")
		CursorMode.HeldCursor:
			_cursor.connect("held_position_moved", self, "_on_cursor_moved")

func _enter_tree():
	var parent = get_parent()
	while parent:
		if parent is NavdiViewerWindow:
			_viewer = parent as NavdiViewerWindow
			print("NavdiCursorFollower %s has _viewer %s" % [name, _viewer.name])
			return
		parent = parent.get_parent()
	_viewer = null
	print("NavdiCursorFollower %s has no _viewer" % [name])

func _on_cursor_moved(pos, move):
	just_pressed = false
	just_released = false
	
	var _changed = false
	if pos == null:
		if pressed:
			_changed = true
			just_released = true
			if not stay_when_released: hide()
			self.pressed = false
	else:
		if _viewer: pos = _viewer.outer_to_inner_vector(pos)
		if round_position: pos = get_round_position(pos)
		pos -= get_viewport().canvas_transform.origin
		
#		pos = get_bounded_position(pos)
		if pos == null and stay_when_released:
			pass
		elif cursor_position != pos:
			_changed = true
			cursor_position = pos
			update_cursor_position(0)
		
		if not pressed:
			_changed = true
			just_pressed = true
			show()
			self.pressed = true
	
	if _changed: emit_signal("cursor_updated")

func update_cursor_position(_delta):
	self.global_position = self.cursor_position

func get_round_position(pos):
	return Vector2(round(pos.x), round(pos.y))

#func get_bounded_position(pos):
#	return Vector2(
#		clamp(pos.x, bounding_rect.position.x, bounding_rect.position.x + bounding_rect.size.x),
#		clamp(pos.y, bounding_rect.position.y, bounding_rect.position.y + bounding_rect.size.y)
#	)
