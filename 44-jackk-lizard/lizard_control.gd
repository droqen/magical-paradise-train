extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(Curve)var tween


var state

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

const PARTIAL_SCALE = .9
const IDLE_POS = Vector2(0,-.4)

func _input(event):
	var can_override_tween = $Tween.is_active() and $Tween.tell() > .8
	if state == States.State.IDLE:
		if (event is InputEventMouseMotion):
			var delta = event.position - Vector2(80,80)
			delta *= .003
			delta.y *= -1
			delta = IDLE_POS + delta
			if can_override_tween:
				$Tween.remove_all()
			if not $Tween.is_active():
				var blend_pos = $lizard_feel.get_blend_position()
				var diff = delta - blend_pos
				diff *= .6
				var target = blend_pos + diff
				$lizard_feel.set_blend_position_unsnapped(target)


func _on_SwipeUp_gesture_progress(offset):
	offset.y *= PARTIAL_SCALE
	if state == States.State.UP:
		offset.y = 1
	offset.y = offset.y*2-1
	$lizard_feel.set_blend_position(offset)


func _on_SwipeDown_gesture_progress(offset):
	match state:
		States.State.RELEASING:
			offset.y *= PARTIAL_SCALE
			offset.y = -offset.y*2+1
			offset.x = -offset.x
			$lizard_feel.set_blend_position(offset)
		States.State.IDLE_CHAIN:
			offset.y = -1
			offset.x = -offset.x
			$lizard_feel.set_blend_position(offset)


func _on_state_machine_state_changed(_old_state, new_state):
	state = new_state
	match new_state:
		States.State.UP:
			tween_to_pos(Vector2(0,1), 1)
		States.State.RELEASING:
			pass
		States.State.IDLE_CHAIN:
			tween_to_pos(Vector2(0,-1), PARTIAL_SCALE)
		States.State.READY:
			tween_to_pos(Vector2(0,-1), PARTIAL_SCALE)
		_:
			go_to_default_position()

func tween_to_pos(offset, scale):
	var duration = .3
	blend_end = offset
	$Tween.remove_all()
	#$Tween.interpolate_method(self, "blend_update", 0, 1, duration, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$lizard_feel.set_blend_position(offset)
	$Tween.interpolate_property($lizard_feel, "scale:y", $lizard_feel.scale.y, scale, duration, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$Tween.start()
	

func go_to_default_position():
	var duration = 3
	blend_end = IDLE_POS
	$Tween.remove_all()
	$Tween.interpolate_method(self, "blend_update", 0, 1, duration, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$Tween.interpolate_property($lizard_feel, "scale:y", $lizard_feel.scale.y, 1, duration, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$Tween.start()

var blend_end = Vector2(0,.3)
func blend_update(t):
	var start = $lizard_feel.get_blend_position()
	var offset = start.linear_interpolate(blend_end, t)
	$lizard_feel.set_blend_position(offset)
	

func _on_lizard_ready_for_pushups():
	visible = true
	go_to_default_position()

var left_count = 0

func _on_lizard_left_pushup_post():
	visible = false
	left_count += 1
	if left_count > 1:
		get_parent().do_win()
