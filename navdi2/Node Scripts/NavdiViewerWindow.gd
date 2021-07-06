tool
extends Container
class_name NavdiViewerWindow

export var min_scale: int = 1
export var max_scale: int = 99
export var viewport_scale: int = 3
export var viewport_scale_lock: bool = false
export var viewport_base_size: Vector2 = Vector2(160, 144)

export (bool) var _refresh = false
export (bool) var _match_board_size = false
export (bool) var passes_mouse_inputs = true
export (bool) var block_out_of_bounds_mouseclicks = true

export (Vector2) var anchor = Vector2(0.5, 0.5)

func outer_to_inner_vector(outer_vector: Vector2):
	return (outer_vector - $ViewportContainer.rect_global_position) / viewport_scale

func inner_to_outer_vector(inner_vector: Vector2):
	return inner_vector * viewport_scale + $ViewportContainer.rect_global_position

func set_viewport_size(_viewport_size: Vector2):
	viewport_base_size =_viewport_size
	refresh()

func _ready():
	var _err
	_err = connect("resized", self, "_on_resized")
	_err = get_viewport().connect("size_changed", self, "_on_resized")
	yield(get_tree(),"physics_frame")
	_on_resized()

func _input(event):
	if passes_mouse_inputs:
		if event is InputEventMouseButton and event.is_pressed() and block_out_of_bounds_mouseclicks:
			if not $ViewportContainer.get_rect().has_point(event.position):
				return # block'd
			
		if event is InputEventMouse or event is InputEventMouseButton or event is InputEventMouseMotion:
			event.position -= $ViewportContainer.rect_position
			if viewport_scale > 1:
				event.position /= viewport_scale
				if event.get('relative'):
					event.relative /= viewport_scale
			$ViewportContainer/Viewport.unhandled_input(event)

func _process(_delta):
	if _refresh and Engine.editor_hint:
		_refresh = false
		_on_resized()
	if _match_board_size and Engine.editor_hint:
		_match_board_size = false
		match_board_size()

func _on_resized():
	refresh()

func scale(a:Vector2,b:Vector2)->Vector2:
	return Vector2(a.x*b.x,a.y*b.y)

func match_board_size():
	viewport_base_size = $ViewportContainer/Viewport.get_child(0).board_view_size
	_on_resized()
	

func refresh():
	_require_viewport_nodes()
	
	if not viewport_scale_lock:
		viewport_scale = int(clamp(min(
			rect_size.x / viewport_base_size.x,
			rect_size.y / viewport_base_size.y
		), min_scale, max_scale))
		property_list_changed_notify()
	
	$ViewportContainer/Viewport.size = viewport_base_size
	$ViewportContainer.stretch = true
	$ViewportContainer.stretch_shrink = viewport_scale
	
	var _child_rect_size = viewport_base_size * viewport_scale
#	var _child_rect_position = (rect_size - $ViewportContainer.rect_size) * 0.5
#	var _child_rect_position = (rect_size - viewport_base_size * viewport_scale) * 0.5
	var _child_rect_position = scale(
			rect_size - viewport_base_size * viewport_scale,
			anchor)
	
	for child in get_children():
		_update_child_rect(child, _child_rect_position, _child_rect_size)

func _update_child_rect(child, _child_rect_position, _child_rect_size):
	child.rect_size = _child_rect_size
	child.rect_position = _child_rect_position

func get_viewed_children() -> Array:
	if has_node("ViewportContainer/Viewport"):
		return $ViewportContainer/Viewport.get_children()
	else:
		return []

func _require_viewport_nodes():
	if not has_node("ViewportContainer"):
		add_child(ViewportContainer.new())
		$ViewportContainer.owner = self.owner if self.owner else self
	if not has_node("ViewportContainer/Viewport"):
		$ViewportContainer.add_child(Viewport.new())
		$ViewportContainer/Viewport.owner = self.owner if self.owner else self
