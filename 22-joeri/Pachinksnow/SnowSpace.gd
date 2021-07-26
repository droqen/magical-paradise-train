extends Node2D

var has_snow = true

func _process(_delta):
	var found_snow = false

	for snowflake in self.get_children():
		if snowflake.current_state != snowflake.STATE.off:
			found_snow = true
	
	self.has_snow = found_snow
