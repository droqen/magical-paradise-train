extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(Curve)var light_curve


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_sunmoon_rot_changed(rot):

	var t = rot/PI/2.0
	# 1 -> .5 = dark
	# .5 -> 0 = day
	var s = light_curve.interpolate(t)
	
	$daysounds.volume_db = -80 + (1-s)*80
	$nightsounds.volume_db = -80 + (s)*90
