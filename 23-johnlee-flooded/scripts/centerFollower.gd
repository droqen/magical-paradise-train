extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(String) var rat1Name
export(String) var rat2Name
var rat1
var rat2
var animComp
var endTimer
# Called when the node enters the scene tree for the first time.
func _ready():
	rat1=get_parent().get_node(rat1Name)
	rat2=get_parent().get_node(rat2Name)
	animComp=get_node("AnimatedSprite")
	endTimer=get_node("Timer")
	pass # Replace with function body.
func OnGameEnd():
	animComp.visible=true
	animComp.animation="appear"
	get_node("kissSound").play()
	endTimer.start()
	#and audio ofc
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position=rat1.position+((rat2.position-rat1.position)*.5)
	
	pass

var endedOnce =false
func _on_right_rat_body_entered(body):
	print("does this even work")
	if(body.name=="left rat" and !endedOnce):
		endedOnce=true
		OnGameEnd()
		$exitChord.play()
		get_parent().get_parent().get_node("prompt/musicLoop").stop()





func SendGameEnd():
	get_parent().get_parent().emit_signal("player_won")
	pass # Replace with function body.
