extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(Curve)var light_curve

var daylight = Color(1,1, 1)
var nightlight = Color(0.247059, 0.247059, 0.454902)

func _on_sunmoon_rot_changed(rot):
	var t = rot/PI/2.0
	# 1 -> .5 = dark
	# .5 -> 0 = day
	var s = light_curve.interpolate(t)
	var new_color = daylight.linear_interpolate(nightlight, s)
	
	modulate = new_color
	
