extends Node2D

var acc = 0
var vel = 0
var pos = 0

signal job_ready
signal job_done
signal rot_changed(rot)

var job_is_done = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pos = rotation
	pass # Replace with function body.

const MAX_VEL = 2
const GRAVITY = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var s = sin(pos)
	acc = s*delta
	if acc > 0: 
		acc *= GRAVITY*3
	else:
		acc *= GRAVITY
		
	if pos > PI and acc < -.0001:
		acc *= 3
		
	vel += acc*delta - vel/2*delta
	vel = clamp(vel, -MAX_VEL, MAX_VEL)
	
	if pos > PI and acc < -0.001 and vel < 0:
		vel = clamp(vel, -MAX_VEL/3.0, MAX_VEL/3.0)
		
	if job_is_done:
		vel = -.5
	
	pos += vel*delta
	
	if job_is_done and pos < PI:
		job_is_done = false
		emit_signal("job_ready")
	
	if pos < 0:
		pos += 2*PI
		job_is_done = true
		emit_signal("job_done")
	
	rotation = pos + 3*PI/2
	emit_signal("rot_changed", pos)

const KICK_AMOUNT = -1.2

func _on_state_machine_do_kick():
	vel = KICK_AMOUNT
