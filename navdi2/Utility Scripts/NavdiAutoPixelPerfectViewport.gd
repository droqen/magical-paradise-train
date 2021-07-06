# original code by CowThing: https://github.com/godotengine/godot/issues/6506
# port to Godot 3 and bugfixes by atomius.

# usage:
# set this script as AutoLoad (Singleton enabled)
#
# in the project settings:
# [display]
# set 'window/size/width' and 'window/size/height' to your desired render resolution.
# set 'window/size/test_width' and 'window/size/test_height' to the initial window size.
# set 'window/stretch/mode' to "viewport"
#
# [rendering]
# set 'quality/2d/use_pixel_snap' to true.


extends Node

onready var root = get_tree().root
onready var base_size = root.get_visible_rect().size
var scale = 1

func _ready():
	# warning-ignore:return_value_discarded
	get_tree().connect("screen_resized", self, "_on_screen_resized")
	
	root.set_attach_to_screen_rect(root.get_visible_rect())
	_on_screen_resized()


func _on_screen_resized():
	var new_window_size = OS.window_size
	
	var scale_w = max(int(new_window_size.x / base_size.x), 1)
	var scale_h = max(int(new_window_size.y / base_size.y), 1)
	scale = min(scale_w, scale_h)
	
	var diff = new_window_size - (base_size * scale)
	var diffhalf = (diff * 0.5).floor()
	
	root.set_attach_to_screen_rect(Rect2(diffhalf, base_size * scale))
	
	# Black bars to prevent flickering:
	var odd_offset = Vector2(int(new_window_size.x) % 2, int(new_window_size.y) % 2)
	
	VisualServer.black_bars_set_margins(
		int(max(diffhalf.x, 0)), # prevent negative values, they make the black bars go in the wrong direction.
		int(max(diffhalf.y, 0)),
		int(max(diffhalf.x, 0) + odd_offset.x),
		int(max(diffhalf.y, 0) + odd_offset.y)
	)



## author - sysharm
## source - https://godotengine.org/qa/25504/pixel-perfect-scaling
#
#extends Node
#
## don't forget to use stretch mode 'viewport' and aspect 'ignore'
#onready var viewport = get_viewport()
#
#func _ready():
#	get_tree().connect("screen_resized", self, "_screen_resized")
#	call_deferred('_screen_resized')
#
#func _screen_resized():
#	var window_size = OS.get_window_size()
#
#	# see how big the window is compared to the viewport size
#	# floor it so we only get round numbers (0, 1, 2, 3 ...)
#	var scale_x = floor(window_size.x / viewport.size.x)
#	var scale_y = floor(window_size.y / viewport.size.y)
#
#	# use the smaller scale with 1x minimum scale
#	var scale = max(1, min(scale_x, scale_y))
#
#	# find the coordinate we will use to center the viewport inside the window
#	var diff = window_size - (viewport.size * scale)
#	var diffhalf = (diff * 0.5).floor()
#
#	# attach the viewport to the rect we calculated
#	viewport.set_attach_to_screen_rect(Rect2(diffhalf, viewport.size * scale))
