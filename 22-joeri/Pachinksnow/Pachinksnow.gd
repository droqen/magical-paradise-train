extends "res://00-core/SubwayStopBoard.gd"

enum STATE {
	startUp,
	snowing,
	clearingUp,
	finished,
}

export (Array, NodePath) var spawnpoints = []
export var total_spawns = 9
export var to_win = 4

var snow_caught = 0
var snow_dropped_count = 0
var current_state
var has_won = false
var has_lost = false

func _ready():
	randomize()
	$FrogSpace.connect("snowflake_eaten", self, "_on_snowflake_eaten")
	$ScoreBoard.set_maximum(self.to_win)
	start_game()

func _process(_delta):
	if self.snow_caught >= self.to_win && !self.has_lost && !self.has_won:
		self.has_won = true
		yield(self.get_tree().create_timer(1), "timeout")
		$WinSound.play()
		emit_signal("player_won")

	if self.current_state == STATE.finished && !$SnowSpace.has_snow && !self.has_lost && !self.has_won:
		self.has_lost = true
		yield(self.get_tree().create_timer(1), "timeout")
		$LoseSound.play()
		emit_signal("player_lost")

func _on_snowflake_eaten():
	$SnowflakeEatenSound.play()
	self.snow_caught += 1
	$ScoreBoard.set_current_score(self.snow_caught)

func start_game():
	self.current_state = STATE.startUp	
	yield(self.get_tree().create_timer(1), "timeout")
	
#	Show everything
	$BootUpSound.play()
	$Clouds.set_animation("turn_on")
	$Clouds.set_frame(1)
	$Floor/FloorFront.show()
	$ScoreBoard.boot_up()

	for snowflake in $SnowSpace.get_children():
		snowflake.boot_up()
	
	for frog in $FrogSpace.get_children():
		frog.boot_up()

#	Wait a bit...
	yield(self.get_tree().create_timer(0.75), "timeout")
	
#	Hide everything
	$Clouds.set_animation("turn_on")
	$Clouds.set_frame(0)
	$Floor/FloorFront.hide()

	yield(self.get_tree().create_timer(0.25), "timeout")
	
#	Turn on the initial parts of the game
	$Floor/FloorFront.show()	
	$ScoreBoard.current_state = 	$ScoreBoard.STATE.on
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
	else:
		stop_snowing()
