tool
extends Node

export(NodePath)var rect_source_path

func _ready():
	if not Engine.editor_hint:
		get_node(rect_source_path).connect("item_rect_changed", self, "_on_source_resized")
		get_node(rect_source_path).connect("resized", self, "_on_source_resized")
		_on_source_resized()

func _on_source_resized():
	var rect_source: Control = get_node(rect_source_path)
	if rect_source == null:
		push_warning("bad rect_source_path '%s' (my path = '%s')" 
			% [rect_source_path,get_path()])
		return
	get_parent().bounding_rect = Rect2(rect_source.rect_global_position, rect_source.rect_size)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _get_configuration_warning():
	if Engine.editor_hint and not rect_source_path:
		return "Assign my Rect Source Path variable to a Control Node"
	return ""
