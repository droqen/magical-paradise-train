extends "res://00-core/SubwayStopBoard.gd"

export (Array, NodePath) var spawnpoints = []
export var spawns = 10;

signal player_won
signal player_lost
signal game_start

enum STATE {
	startUp,
	snowing,
	clearingUp,
	finished,
}

var snow_dropped_count = 0;

func on_game_start():
	emit_signal("game_start")

func _ready():
	start_snowing();

func start_snowing():
	$Clouds.play("get_cloudy")
	yield($Clouds, "animation_finished")
	spawn_snow();

func stop_snowing():
	$Clouds.play("clear_up")

func spawn_snow():
	var spawnpoint = get_node(spawnpoints[randi() % spawnpoints.size()])
	spawnpoint.current_state = spawnpoint.STATE.on

	self.snow_dropped_count += 1
	if self.snow_dropped_count < spawns:
		$SnowSpawn.start()
		yield($SnowSpawn, "timeout")
		spawn_snow()
	else:
		stop_snowing()
