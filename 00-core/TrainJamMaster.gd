extends Node

export(PackedScene)var test_microgame_scene: PackedScene = null
var all_microgames = [] # a list of all available microgames
var microgame_stack: Array = [] # pop from this to get the next microgame

var current_microgame: MicrogameMetadata = null
var preloaded_microgame: MicrogameMetadata = null
export(Curve)var viewport_slide_in
export(Curve)var viewport_slide_out

var microgame_instance = null

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
	preload_games()
	randomize()
	load_first_game()
	
	var _err = Global.connect("SKIP_REQUESTED",self,"skip_microgame")
	
func preload_games():
	var directory = Directory.new()
	var error = directory.open("res://00-core/metromap")
	if error == OK:
		directory.list_dir_begin()
		var file_name = directory.get_next()
		while (file_name != ""):
			if not directory.current_is_dir() and file_name[0] != "_":
				
				var minigame = load(directory.get_current_dir()+"/"+file_name)
				all_microgames.push_back(minigame)
				#print(str(all_microgames))
			file_name = directory.get_next()

func load_first_game():
	if test_microgame_scene:
		load_next_microgame()
		set_microgame_state(MgState.DoorsOpening)
	else:
		set_microgame_state(MgState.ChillingABit)
		stateTimer = stateDuration # instantly slide in

func load_next_microgame():
	preload_next_microgame()
	set_current_microgame(preloaded_microgame)
	preloaded_microgame = null

func preload_next_microgame():
	if test_microgame_scene:
		var test_microgame = MicrogameMetadata.new()
		test_microgame.microgame_name = "Test"
		test_microgame.microgame_name = "YOU"
		test_microgame.microgame_scene = test_microgame_scene
		preload_microgame(test_microgame)
	else:
		if len(microgame_stack)==0:
			microgame_stack=all_microgames.duplicate()
			microgame_stack.shuffle()
		var mg=microgame_stack.pop_back()
		assert(mg, "TrainJamMaster.all_microgames is empty; add some!")
		preload_microgame(mg)

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
	self.microgame_instance = null

func set_current_microgame(mg: MicrogameMetadata):
	unload_current_scene()
	
	Global.current_microgame_md = mg
	
	self.current_microgame = mg
	var nvw = $"../MarginContainer/NavdiViewerWindow"
	var vpc = $"../MarginContainer/NavdiViewerWindow/ViewportContainer"
	var vp = $"../MarginContainer/NavdiViewerWindow/ViewportContainer/Viewport"
	microgame_instance = current_microgame.microgame_scene.instance()
	vp.add_child(microgame_instance)
	microgame_instance.owner = vp.owner
	vpc.show()
	
	microgame_instance.connect("player_won", self, "set_microgame_state", [MgState.DoorsClosing])
	microgame_instance.connect("player_lost", self, "set_microgame_state", [MgState.DoorsClosing])
	
	nvw.match_board_size()
	

func _process(delta):
	stateTimer += delta # current state: advance timer
	match microgameState:
		MgState.ChillingABit:
			get_tree().paused = true
			if stateTimer > stateDuration:
				load_next_microgame()
				set_microgame_state(MgState.GameSlidingIn)
			
		MgState.GameSlidingIn:
			get_tree().paused = true
			_update_slide_position()
			if stateTimer > stateDuration:
				set_microgame_state(MgState.DoorsOpening)
		MgState.DoorsOpening:
			get_tree().paused = true
			_update_slide_position()
			if stateTimer > stateDuration:
				set_microgame_state(MgState.PlayingTheGame)
				print(microgame_instance.name)
				microgame_instance.on_game_start()
				
				
				
		MgState.PlayingTheGame:
			
			# do nothing. wait for the game to end itself.
			pass
		MgState.DoorsClosing:
			_update_slide_position()
			if stateTimer > stateDuration:
#				print("yep ",stateTimer, " > ",stateDuration)
				set_microgame_state(MgState.GameSlidingOut)
		MgState.GameSlidingOut:
			get_tree().paused = true
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
			stateDuration = 3.0
		MgState.DoorsOpening:
			train_car.open_doors();
			stateDuration = 0.6 # time before game starts
		MgState.PlayingTheGame:
			Global.is_microgame_playing = true
			get_tree().paused = false
			stateDuration = -1
		MgState.DoorsClosing:
			Global.is_microgame_playing = false
			train_car.close_doors();
			stateDuration = 1.0 # how long is the animation?
		MgState.GameSlidingOut:
			stateDuration = 2.0
		MgState.ChillingABit:
			stateDuration = 2.0
	_update_slide_position()
	
	
func skip_microgame():
	set_microgame_state(MgState.DoorsClosing)
