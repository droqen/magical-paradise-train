tool
extends Node

export(NodePath)var viewport_container_path
onready var _viewportcontainer = get_node(viewport_container_path)

func _process(_delta):
	if not Engine.editor_hint and _viewportcontainer:
		get_parent().margin_scale = _viewportcontainer.stretch_shrink

func _get_configuration_warning():
	if Engine.editor_hint and not viewport_container_path:
		return "Assign my Viewport Container Path variable to a Control Node"
	return ""
