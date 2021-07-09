extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var _err = $EndGameTimer.connect("timeout",self,"OnTimeout")


func GameOver():
	if $EndGameTimer.is_stopped():
		$EndGameTimer.start()
	

func OnTimeout():
	get_parent().emit_signal("player_won")
