extends Node2D

var won = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_child_count() == 0 and not won:
		won = true
		get_parent().emit_signal("player_won")
