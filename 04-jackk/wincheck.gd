extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

const MIN = 40
const MAX = 45
const TO_WIN = 5

var win_counter = 0
var last_wave = 0

func record_wave_step(rot):
	var now = OS.get_ticks_msec()
	var too_slow = now-last_wave > 600
	var too_short = abs(rot_at_reverse - rot) < 5
	if win_counter > 0 and (too_slow or too_short):
		win_counter = 0
		return
		
	win_counter+=1
	last_wave = OS.get_ticks_msec()
	
	match win_counter:
		1:
			$mid.play()
		2:
			$low.play()
		3:
			$low.play()
		4:
			$low.play()


	
var last_rot_delta = 0
var rot_at_reverse = 0


func _on_waver_rot_changed(delta):
	if win_counter == TO_WIN or !played:
		return
	
	var rotation_reversing = last_rot_delta * delta < 0
	
	var sunscale = $sun/glare.scale.x
	if(sunscale < 1.2):
		var rot = $waver.rotation_degrees
		
		if rotation_reversing:
			record_wave_step(rot)
				
		if win_counter == TO_WIN:
			get_parent().emit_signal("player_won")
			$get.play()
	else:
		win_counter = 0
		
	if rotation_reversing:
		rot_at_reverse = $waver.rotation_degrees
	last_rot_delta = delta

var played = false
var scale_counter = 0
func _on_sun_scale_changed(sunscale):
	print(sunscale)
	if(sunscale < .7):
		if !played:
			#scale_counter+=1
			#if(scale_counter > 10):
			$ahh.play()
			print("ahhh...")
			played = true
	else:
		scale_counter =0 
		played = false
