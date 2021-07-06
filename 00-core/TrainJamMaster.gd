extends Node

var gameboard_loader: ResourceInteractiveLoader = null
var gameboard_loader_artificial_delay: float = 1.0

export(Curve)var viewport_slide_in
export(Curve)var viewport_slide_out
var slide_progress = 0
var sliding_in = false
var sliding_out = false

var gameboard_index = 0
var gameboard_paths = [
	"res://01-droqen/TestPlatformer2.tscn",
	"res://01-droqen/TestPlatformer.tscn"
]

func _ready():
	load_next_gameboard()
	slide_progress = 1

func load_next_gameboard():
	if load_gameboard_path(gameboard_paths[gameboard_index]):
		gameboard_index += 1
		if gameboard_index >= len(gameboard_paths):
			gameboard_index = 0

func load_gameboard_path(path: String):
	if gameboard_loader != null:
		show_error("ALREADY LOADING")
		return false
	
	gameboard_loader_artificial_delay = randf()
	gameboard_loader = ResourceLoader.load_interactive(path)
	if gameboard_loader == null:
		show_error("BAD PATH "+path)
		return false
	
	# play 'loading' animation?
	sliding_in = false
	sliding_out = true
	slide_progress = 0
	
	return true

func unload_current_scene():
	var vpc = $"../MarginContainer/NavdiViewerWindow/ViewportContainer"
	var vp = $"../MarginContainer/NavdiViewerWindow/ViewportContainer/Viewport"
	vpc.hide()
	for child in vp.get_children():
		vp.remove_child(child)
		child.queue_free()

func assign_packed_scene(packed_scene:PackedScene):
	unload_current_scene()
	var nvw = $"../MarginContainer/NavdiViewerWindow"
	var vpc = $"../MarginContainer/NavdiViewerWindow/ViewportContainer"
	var vp = $"../MarginContainer/NavdiViewerWindow/ViewportContainer/Viewport"
	var scene = packed_scene.instance()
	vp.add_child(scene)
	scene.owner = vp.owner
	vpc.show()
	
	scene.connect("player_won", self, "load_next_gameboard")
	scene.connect("player_lost", self, "load_next_gameboard")
	
	nvw.match_board_size()

func _process(delta):
	if gameboard_loader:
	
		if sliding_out:
			slide_progress += delta * 0.85
			_update_slide_position()
			if slide_progress >= 1:
				unload_current_scene()
				sliding_out = false
		elif sliding_in:
			slide_progress += delta * 0.5
			_update_slide_position()
			if slide_progress >= 1:
				gameboard_loader = null
				sliding_in = false
		else:
			var err = gameboard_loader.poll()
			if err == ERR_FILE_EOF: # Finished loading.
				if sliding_out:
					pass
				elif gameboard_loader_artificial_delay > 0:
					gameboard_loader_artificial_delay -= delta
					pass
				else:
					var resource = gameboard_loader.get_resource()
#					gameboard_loader = null
					assign_packed_scene(resource)
					sliding_in = true
					slide_progress = 0
					_update_slide_position()
			elif err == OK:
				pass#update_progress()
			else: # Error during loading.
				show_error("ERROR DURING LOADING")
				gameboard_loader = null
	#		break

func _update_slide_position():
	var nvw = $"../MarginContainer/NavdiViewerWindow"
	var window_size = $"../MarginContainer".rect_size
	var offset = Vector2.ZERO
	if sliding_in:
		offset = Vector2.RIGHT * window_size * viewport_slide_in.interpolate(slide_progress)
	elif sliding_out:
		offset = Vector2.LEFT * window_size * viewport_slide_out.interpolate(slide_progress)
	nvw.refresh()
	for child in nvw.get_children():
		child.rect_position += offset
#	vpc.rect_position = Vector2.ZERO + offset

func show_error(msg):
	print("TrainJamMaster load error: %s" % msg)
