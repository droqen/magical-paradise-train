extends Node

signal state_changed(old_state, new_state)
signal do_kick


var state = States.State.IDLE

var enabled = true

func _on_lizard_ready_for_pushups():
	enabled = true
	switch_to_state(States.State.IDLE)


func _on_lizard_left_pushup_post():
	enabled = false


func print_state(to_print):
	match to_print :
		States.State.READY:
			print("READY")
		States.State.UP:
			print("UP")
		States.State.RELEASING:
			print("RELEASING")
		States.State.IDLE:
			print("IDLE")
		States.State.IDLE_CHAIN:
			print("IDLE_CHAIN")
		States.State.FALL:
			print("FALL")
		States.State.STRESSED:
			print("STRESSED")
		States.State.STRESSED_FALL:
			print("STRESSED_FALL")

func switch_to_state(new_state):
	if not enabled:
		return
	
	var old_state = state
	state = new_state
	#print_state(state)
	emit_signal("state_changed", old_state, new_state)


func _on_SwipeUp_initiated(_pos):
	match state:
		States.State.IDLE, States.State.IDLE_CHAIN:
			switch_to_state(States.State.READY)

func _on_SwipeUp_detected():
	match state:
		States.State.READY:
			emit_signal("do_kick")
			switch_to_state(States.State.UP)


func _on_SwipeUp_failed(_detected):
	match state:
		States.State.READY:
			switch_to_state(States.State.STRESSED)
		States.State.UP:
			switch_to_state(States.State.STRESSED_FALL)


func _on_SwipeDown_initiated(_pos):
	match state:
		States.State.READY:
			switch_to_state(States.State.STRESSED)
			switch_to_state(States.State.IDLE)
		States.State.UP:
			switch_to_state(States.State.RELEASING)
		States.State.STRESSED:
			switch_to_state(States.State.IDLE)

func _on_SwipeDown_detected():
	match state:
		States.State.RELEASING:
			emit_signal("do_kick")
			switch_to_state(States.State.IDLE_CHAIN)

func _on_SwipeDown_failed(_detected):
	match state:
		States.State.RELEASING, States.State.IDLE_CHAIN:
			switch_to_state(States.State.FALL)

func _process(_delta):
	match state:
		States.State.FALL:
			switch_to_state(States.State.IDLE)
		States.State.STRESSED_FALL:
			switch_to_state(States.State.STRESSED)
