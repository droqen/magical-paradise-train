extends Node2D
var actions = []
var action_count = 20
var progress = 0
var rat_hands_together = false
var you_hands_together = false

onready var rat_target_left = $Rat/right_left.position
onready var rat_target_right = $Rat/left_right.position
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in action_count:
		actions.append(randi()%4)
	telegraph_hands()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$YourHands/right/back.visible = !you_hands_together
	$YourHands/left/back.visible = !you_hands_together
	$YourHands/right/side.visible = you_hands_together
	$YourHands/left/side.visible = you_hands_together
	
	$YourHands/left.position = lerp($YourHands/left.position, $YourHands/left_idle.position, delta*4)
	$YourHands/right.position = lerp($YourHands/right.position, $YourHands/right_idle.position, delta*4)
	
	
	$Rat/right/front.visible = !rat_hands_together
	$Rat/left/front.visible = !rat_hands_together
	$Rat/right/side.visible = rat_hands_together
	$Rat/left/side.visible = rat_hands_together
	
	$Rat/left.position = lerp($Rat/left.position, rat_target_left, delta*6)
	$Rat/right.position = lerp($Rat/right.position, rat_target_right, delta*6)
	
	var input = -1
	if Input.is_action_just_pressed("ui_up"):
		input = 0
	if Input.is_action_just_pressed("ui_right"):
		input = 1
	if Input.is_action_just_pressed("ui_down"):
		input = 2
	if Input.is_action_just_pressed("ui_left"):
		input = 3
	
	if input != -1 and progress < action_count:
		you_hands_together = input == 2
		match input:
			0:
				$YourHands/left.position = $YourHands/up_left.position
				$YourHands/right.position = $YourHands/up_right.position
			1:
				$YourHands/left.position = $YourHands/right_left.position
				$YourHands/right.position = $YourHands/right_right.position
			2:
				$YourHands/left.position = $YourHands/down_left.position
				$YourHands/right.position = $YourHands/down_right.position
			3:
				$YourHands/left.position = $YourHands/left_left.position
				$YourHands/right.position = $YourHands/left_right.position
		if input == actions[progress]:
			progress += 1
			$Rat.pos = 0.5
			$Rat.speed = 30
			$Clap.play()
			
			
			
			match input:
				0:
					$Rat/left.position = $Rat/up_left.position
					$Rat/right.position = $Rat/up_right.position
				1:
					$Rat/left.position = $Rat/right_left.position
					$Rat/right.position = $Rat/left_right.position
				2:
					$Rat/left.position = $Rat/down_left.position
					$Rat/right.position = $Rat/down_right.position
				3:
					$Rat/left.position = $Rat/left_left.position
					$Rat/right.position = $Rat/left_right.position
					
			
			if progress >= action_count:
				get_parent().emit_signal("player_won")
			else:
				telegraph_hands()
		else:
			$Wrong.play()
		
	pass

func telegraph_hands():
	rat_hands_together = actions[progress] == 2
	match actions[progress]:
		0: 
			$Label.text = "up"
			rat_target_left = $Rat/anticipation/up_left.position
			rat_target_right = $Rat/anticipation/up_right.position
		1: 
			$Label.text = "right"
			rat_target_left = $Rat/anticipation/right_left.position
			rat_target_right = $Rat/anticipation/right_right.position
		2: 
			$Label.text = "down"
			rat_target_left = $Rat/anticipation/down_left.position
			rat_target_right = $Rat/anticipation/down_right.position
		3: 
			$Label.text = "left"
			rat_target_left = $Rat/anticipation/left_left.position
			rat_target_right = $Rat/anticipation/left_right.position
	pass
