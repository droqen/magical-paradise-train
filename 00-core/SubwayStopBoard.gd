tool
extends NavdiBoard

signal player_won
signal player_lost
signal game_start
# subway stop name? nah

func spawn_tiledmanager(): pass #nah


func on_game_start():
	#print("micro game starting")
	
	emit_signal("game_start")
#emit_signal("player_won")
