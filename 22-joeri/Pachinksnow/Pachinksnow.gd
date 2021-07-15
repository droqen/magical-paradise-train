extends "res://00-core/SubwayStopBoard.gd"

enum STATE {
	startUp,
	snowing,
	clearingUp,
	finished,
}

export (Array, NodePath) var spawnpoints = []
export var total_spawns = 8
export var to_win = 3

var snow_caught = 0
var snow_dropped_count = 0
var current_state

func _ready():
	randomize()
	start_game();

func _process(_delta):
	if self.current_state == STATE.finished && !$SnowSpace.has_snow:
		emit_signal("player_lost")

func start_game():
	self.current_state = STATE.startUp	
	yield(self.get_tree().create_timer(1), "timeout")
	
	$Clouds.set_animation("turn_on")
	$Clouds.set_frame(1)
	
	for snowflake in $SnowSpace.get_children():
		snowflake.boot_up()
	
	for frog in $FrogSpace.get_children():
		frog.boot_up()

	yield(self.get_tree().create_timer(0.5), "timeout")
	
	$Clouds.set_animation("turn_on")
	$Clouds.set_frame(0)

	yield(self.get_tree().create_timer(0.25), "timeout")
	
	$FrogSpace/WalkingFrog1.current_state = $FrogSpace/WalkingFrog1.STATE.on
	start_snowing()	
	
func start_snowing():
	$Clouds.play("get_cloudy")
	yield($Clouds, "animation_finished")
	self.current_state = STATE.snowing
	spawn_snow();

func stop_snowing():
	self.current_state = STATE.clearingUp
	$Clouds.play("clear_up")
	yield($Clouds, "animation_finished")
	self.current_state = STATE.finished

func spawn_snow():
	var spawnpoint = get_node(spawnpoints[randi() % spawnpoints.size()])
	spawnpoint.turn_on()

	self.snow_dropped_count += 1
	if self.snow_dropped_count < self.total_spawns:
		$SnowSpawn.start()
		yield($SnowSpawn, "timeout")
		spawn_snow()
	elif self.snow_caught >= self.to_win:
		emit_signal("player_won")
	else:
		stop_snowing()
