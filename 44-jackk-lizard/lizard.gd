extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var start_point
var start_scale

signal ready_for_pushups
signal left_pushup_post

const tween_time = 1
const dest_scale = Vector2(.1,.1)

var dest_position


# Called when the node enters the scene tree for the first time.
func _ready():
	start_point = global_position
	start_scale = scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_state_machine_state_changed(_old_state, new_state):
	match new_state:
		States.State.UP, States.State.RELEASING:
			set_frame(1)
		_:
			set_frame(0)


func _on_sunmoon_job_done():
	yield(get_tree().create_timer(.5), "timeout")
	move_to_bush()


func _on_sunmoon_job_ready():
	yield(get_tree().create_timer(.5), "timeout")
	move_to_stump()


func move_to_bush():
	visible = true
	$stump_tween.remove_all()
	emit_signal("left_pushup_post")
	play("walk")
	$bush_tween.interpolate_property(self, "position", start_point, dest_position, tween_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$bush_tween.interpolate_property(self, "scale", start_scale, dest_scale, tween_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$bush_tween.start()

func _on_bush_tween_tween_completed(_object, _key):
	$bush_tween.remove_all()
	stop()
	flip_h = true
	animation = "pushup"
	set_frame(0)
	scale = Vector2(0,0)
	update()


func move_to_stump():
	scale = dest_scale
	$bush_tween.remove_all()
	play("walk")
	$stump_tween.interpolate_property(self, "position", dest_position, start_point, tween_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$stump_tween.interpolate_property(self, "scale", dest_scale, start_scale, tween_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$stump_tween.start()
	pass

func _on_stump_tween_tween_completed(_object, _key):
	$stump_tween.remove_all()
	stop()
	flip_h = false
	animation = "pushup"
	visible = false
	set_frame(0)
	update()
	emit_signal("ready_for_pushups")


