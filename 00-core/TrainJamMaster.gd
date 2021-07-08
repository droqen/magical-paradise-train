extends Node

var microgame_index = 0

export(PackedScene)var test_microgame_scene: PackedScene = null
export(bool)var test_microgame_repeating = true
export(Array, Resource)var microgames = []

var current_microgame: MicrogameMetadata = null
var preloaded_microgame: MicrogameMetadata = null
export(Curve)var viewport_slide_in
export(Curve)var viewport_slide_out

onready var train_car = $"../TrainCar"

enum MgState{
	GameSlidingIn = 15,
	DoorsOpening = 16,
	PlayingTheGame = 25,
	DoorsClosing = 34,
	GameSlidingOut = 35,
	ChillingABit = 45,
}

var microgameState = MgState.ChillingABit
var stateTimer = 0.0
var stateDuration = 1.0

func _ready():
	load_first_game()

func load_first_game():
	set_microgame_state(MgState.ChillingABit)
	stateTimer = stateDuration # instantly slide in

func preload_next_microgame():
	if test_microgame_scene:
		var test_microgame = MicrogameMetadata.new()
		test_microgame.microgame_name = "Test"
		test_microgame.microgame_name = "YOU"
		test_microgame.microgame_scene = test_microgame_scene
		if not test_microgame_repeating:
			test_microgame_scene = null
		preload_microgame(test_microgame)
	else:
		preload_microgame(microgames[microgame_index])
		microgame_index += 1
		if microgame_index >= len(microgames):
			microgame_index = 0

func preload_microgame(mg: MicrogameMetadata):
	preloaded_microgame = mg

func unload_current_scene():
	var vpc = $"../MarginContainer/NavdiViewerWindow/ViewportContainer"
	var vp = $"../MarginContainer/NavdiViewerWindow/ViewportContainer/Viewport"
	vpc.hide()
	for child in vp.get_children():
		vp.remove_child(child)
		child.queue_free()
	self.current_microgame = null

func set_current_microgame(mg: MicrogameMetadata):
	unload_current_scene()
	self.current_microgame = mg
	var nvw = $"../MarginContainer/NavdiViewerWindow"
	var vpc = $"../MarginContainer/NavdiViewerWindow/ViewportContainer"
	var vp = $"../MarginContainer/NavdiViewerWindow/ViewportContainer/Viewport"
	var scene = current_microgame.microgame_scene.instance()
	vp.add_child(scene)
	scene.owner = vp.owner
	vpc.show()
	
	scene.connect("player_won", self, "set_microgame_state", [MgState.DoorsClosing])
	scene.connect("player_lost", self, "set_microgame_state", [MgState.DoorsClosing])
	
	nvw.match_board_size()
	

func _process(delta):
	stateTimer += delta # current state: advance timer
	match microgameState:
		MgState.ChillingABit:
			if stateTimer > stateDuration:
				preload_next_microgame()
				set_current_microgame(preloaded_microgame)
				preloaded_microgame = null
				set_microgame_state(MgState.GameSlidingIn)
		MgState.GameSlidingIn:
			_update_slide_position()
			if stateTimer > stateDuration:
				set_microgame_state(MgState.DoorsOpening)
		MgState.DoorsOpening:
			_update_slide_position()
			if stateTimer > stateDuration:
				set_microgame_state(MgState.PlayingTheGame)
		MgState.PlayingTheGame:
			# do nothing. wait for the game to end itself.
			pass
		MgState.DoorsClosing:
			_update_slide_position()
			if stateTimer > stateDuration:
				print("yep ",stateTimer, " > ",stateDuration)
				set_microgame_state(MgState.GameSlidingOut)
		MgState.GameSlidingOut:
			_update_slide_position()
			if stateTimer > stateDuration:
				unload_current_scene()
				set_microgame_state(MgState.ChillingABit)

func _update_slide_position():
	var nvw = $"../MarginContainer/NavdiViewerWindow"
	var window_size = $"../MarginContainer".rect_size
	var offset = Vector2.ZERO
	
	match microgameState:
		MgState.GameSlidingIn:
			offset = Vector2.RIGHT * window_size * viewport_slide_in.interpolate(stateTimer/stateDuration)
		MgState.PlayingTheGame:
			offset = Vector2.ZERO # stay in the middle
		MgState.GameSlidingOut:
			offset = Vector2.LEFT * window_size * viewport_slide_out.interpolate(stateTimer/stateDuration) * 1.1
		MgState.ChillingABit:
			offset = Vector2.LEFT * window_size * 2 # stay off to the left there
	
	nvw.refresh()
	for child in nvw.get_children():
		child.rect_position += offset
#	vpc.rect_position = Vector2.ZERO + offset

func show_error(msg):
	print("TrainJamMaster load error: %s" % msg)

func set_microgame_state(state):
	microgameState = state
	stateTimer = 0.0
	match microgameState:
		MgState.GameSlidingIn:
			stateDuration = 2.0
		MgState.DoorsOpening:
			train_car.open_doors();
			stateDuration = 0.25 # how long is the animation?
		MgState.PlayingTheGame:
			stateDuration = -1
		MgState.DoorsClosing:
			train_car.close_doors();
			stateDuration = 1.0 # how long is the animation?
		MgState.GameSlidingOut:
			stateDuration = 2.0
		MgState.ChillingABit:
			stateDuration = 2.0
	_update_slide_position()
