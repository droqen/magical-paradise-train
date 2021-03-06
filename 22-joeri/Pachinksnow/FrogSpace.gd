extends Node2D

signal snowflake_eaten

func _ready():
	for frog in self.get_children():
		frog.connect("snowflake_eaten", self, "_on_snowflake_eaten")

func _process(_delta):
	var current_frog
	for frog in self.get_children():
		if frog.current_state == frog.STATE.on:
			current_frog = frog
	
	if !current_frog:
		return
	
	var to_frog
	
	if Input.is_action_just_pressed("ui_left") && current_frog.left_frog:
		to_frog = current_frog.left_frog
	
	if Input.is_action_just_pressed("ui_right") && current_frog.right_frog:
		to_frog = current_frog.right_frog
	
	if to_frog:
		current_frog.current_state = current_frog.STATE.off
		to_frog.current_state = to_frog.STATE.on

func _on_snowflake_eaten():
	emit_signal("snowflake_eaten")
