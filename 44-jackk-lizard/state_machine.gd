extends Node

signal state_changed(old_state, new_state)
signal do_kick


var state = States.State.IDLE

var enabled = true

func _ready():
	$Sprite.visible = false

func _on_lizard_ready_for_pushups():
	enabled = true
	switch_to_state(States.State.IDLE)
	$Sprite.visible = false


func _on_lizard_left_pushup_post():
	enabled = false
	$Sprite.visible = false


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
	if not enabled:
		return
		
	match state:
		States.State.IDLE, States.State.IDLE_CHAIN:
			switch_to_state(States.State.READY)
			if not $Sprite.visible:
				$Sprite.visible = true
				$Sprite.position = Vector2(_pos.x, _pos.y - 25)
			else:
				$Tween.interpolate_property($Sprite, "position", $Sprite.position, Vector2(_pos.x, _pos.y-25), .1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
				$Tween.start()

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
	$Sprite.visible = false


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
	$Sprite.visible = false

func _process(_delta):
	match state:
		States.State.FALL:
			switch_to_state(States.State.IDLE)
		States.State.STRESSED_FALL:
			switch_to_state(States.State.STRESSED)
