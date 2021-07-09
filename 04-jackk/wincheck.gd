extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

const MIN = 40
const MAX = 45
const TO_WIN = 5
const MIN_ROT_DIFF = 10

var win_counter = 0
var last_wave = 0

func record_wave_step(rot):
	var now = OS.get_ticks_msec()
	var too_slow = now-last_wave > 600
	var too_short = abs(rot_at_reverse - rot) < MIN_ROT_DIFF
	if win_counter > 0 and (too_slow or too_short) or need_to_play_woosh:
		win_counter = 0
		need_to_play_woosh = true
		return
		
	win_counter+=1
	last_wave = OS.get_ticks_msec()
	need_to_play_woosh = true
	


	
var last_rot_delta = 0
var rot_at_reverse = 0
var need_to_play_woosh = true

var particle_pack = preload("res://04-jackk/arm-particle.tscn")

func create_particle(rot, delta):
	var particle = particle_pack.instance()
	particle.rotation_speed = delta*15
	var offset = Vector2(cos(rot), -sin(rot))*70
	particle.start_point = $waver.global_position + offset
	particle.target_point = $Line2D.global_position
	particle.start_rotation = rot
	if played:
		particle.modulation = Color(0xc7ffc388) 
	else: 
		particle.modulation = Color(0xa6d0ff88)
	add_child(particle)
	$woosh3.play()

func _on_waver_rot_changed(delta):
	if win_counter == TO_WIN:
		return
	
	var rotation_reversing = last_rot_delta * delta < 0
	var rot = $waver.rotation_degrees
	
	var too_short = abs(rot_at_reverse - rot) < MIN_ROT_DIFF
	if !too_short and need_to_play_woosh and rot > 0 and rot < 90 and abs(delta) > .2:
		create_particle($waver.rotation, delta)
		
		need_to_play_woosh = false
		match win_counter:
			1:
				$mid.play()
			2:
				$low.play()
			3:
				$low.play()
			4:
				$low.play()
				
	var sunscale = $sun/glare.scale.x
	if played and sunscale < 1.2:
			
		if rotation_reversing:
			record_wave_step(rot)
				
		if win_counter == TO_WIN:
			$get.play()
			wait_to_win()
	else:
		win_counter = 0
		
	if rotation_reversing:
		rot_at_reverse = $waver.rotation_degrees
		need_to_play_woosh = true
	last_rot_delta = delta

func wait_to_win():
	yield(get_tree().create_timer(1.0), "timeout")
	get_parent().emit_signal("player_won")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



var played = false
func _on_sun_scale_changed(sunscale):
	if(sunscale < .7):
		if !played:
			$ahh.play()
			$Line2D.default_color = Color(0x67bc63ff)
			played = true
	else:
		played = false
