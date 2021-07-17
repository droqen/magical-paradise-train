extends Node2D

onready var tween = $Tween
onready var judge = $judge


var judge_end_pos = Vector2(-3, -19)



# Called when the node enters the scene tree for the first time.
func _ready():
	#judge_end_pos = judge.position
	judge.position.y = 240


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ScratchManager_end_gameplay(score):
	tween.interpolate_property(judge, "position", judge.position, judge_end_pos, 0.425, Tween.TRANS_BACK,Tween.EASE_OUT)
	tween.start()
	print("calling judge up")
	yield(get_tree().create_timer(0.43), "timeout")
	judge.target_x = 1.7
	$Explain.text = "Your"
	yield(get_tree().create_timer(0.125), "timeout")
	judge.target_x = 0.65
	$Explain.text = "Your score"
	yield(get_tree().create_timer(0.17), "timeout")
	judge.target_x = 2.2
	$Explain.text = "Your score is"
	tween.interpolate_property(judge, "rotation_degrees", 0, judge_end_pos, 0.375, Tween.TRANS_ELASTIC,Tween.EASE_OUT)
	yield(get_tree().create_timer(0.4), "timeout")
	judge.target_x = 2.2
	$Score.text = str(score)
	for i in range(0, randi()%5):
		yield(get_tree().create_timer(0.1), "timeout")
		$Score.text += "!"		
	yield(get_tree().create_timer(3), "timeout")
	get_parent().emit_signal("player_won")


func _on_Instructions_start_game():
	pass # Replace with function body.
