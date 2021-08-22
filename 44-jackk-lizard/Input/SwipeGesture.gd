extends Node

signal initiated(pos)
signal motion_started
signal gesture_progress(offset) #offset.x is between -1 and 1, offset.y is between 0 and 1
signal detected
signal settled(pos)
signal released()
signal failed(detected)


export var detection_length = 50
export var direction = Vector2(0,-1)
export var start_on_click = true

var swipe_started
var motion_started
var swipe_detected
var swipe_settled
var mouse_down_pos

var last_mouse_pos
var settled_mouse_pos


func _input(event):
	if (event is InputEventMouseMotion):
		_on_mouse_motion(event)
	if (event is InputEventMouseButton):
		_on_mouse_button(event)

func _on_mouse_motion(event):
	if swipe_started:
		var delta = event.position - mouse_down_pos
		var y_prog = direction.dot(delta)
		var x_prog = direction.rotated(PI/2).dot(delta)
		var progress = Vector2(x_prog, y_prog)
		progress.x /= 10
		progress.y /= detection_length
		emit_signal("gesture_progress", progress)
		if !swipe_detected:
			#note start of motion
			if !motion_started:
				motion_started = true
				emit_signal("motion_started")
			#check for backwards motion
			var dot = event.relative.dot(direction)
			if motion_started and progress.y > 0.02 and dot < 0:
				fail()
				return 
			#update timer
			last_mouse_pos = event.position
			start_fail_timer()
			#check gesture progress
			var diff = direction.dot(delta)
			if diff > detection_length:
				emit_signal("detected")
				swipe_detected = true
				$FailTimer.stop()
			else:
				#fail if strayed too far before detecting gesture
				var stray = GraphicUtil.DistanceToLineSegment(mouse_down_pos, mouse_down_pos+direction*detection_length, event.position)
				if stray > 10:
					fail()
		elif swipe_detected:
			if swipe_settled:
				#fail if straying too far after settling
				var diff = event.position.distance_to(settled_mouse_pos)
				if diff > 20:
					fail()
			else:
				#keep restarting timer after detection, until settled
				last_mouse_pos = event.position
				start_fail_timer()
				#fail if strayed too far before settling
				var stray = GraphicUtil.DistanceToLine(mouse_down_pos, direction, event.position)
				if stray > 10:
					fail()

func _on_mouse_button(event):
	if event.button_index == BUTTON_LEFT:
		if event.pressed == start_on_click:
			mouse_pressed(event)
		else:
			mouse_released(event)

func mouse_pressed(event):
	swipe_started = true
	mouse_down_pos = event.position
	emit_signal("initiated", mouse_down_pos)

func mouse_released(_event):
	if swipe_started:
		if swipe_detected:
			emit_signal("released")
		else:
			emit_signal("failed", swipe_detected)
	cleanup()

func cleanup():
	swipe_started = false
	motion_started = false
	swipe_detected = false
	swipe_settled = false
	mouse_down_pos = null
	last_mouse_pos = null
	settled_mouse_pos = null
	$FailTimer.stop()

func fail():
	#print("failed")
	emit_signal("failed", swipe_detected)
	cleanup()

func start_fail_timer():
	$FailTimer.start(.1)

func _on_FailTimer_timeout():
	if swipe_detected:
		settled_mouse_pos = last_mouse_pos
		emit_signal("settled", settled_mouse_pos)
		swipe_settled = true
   # else:
		#fail()
