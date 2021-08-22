extends Node2D

func set_blend_position_unsnapped(offset):
	
	$AnimationTree.set("parameters/blend_position", offset)

func set_blend_position(offset):
	
	if abs(offset.x) < .2:
		offset.x = 0
	$AnimationTree.set("parameters/blend_position", offset)

func get_blend_position():
	return $AnimationTree.get("parameters/blend_position")
