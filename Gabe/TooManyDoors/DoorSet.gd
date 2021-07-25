extends Node2D

var doorSize = Vector2(324,560)


func _ready():
	pass # Replace with function body.

func SetScale(newScale):
	scale = newScale
	global_position.x += (1-newScale.x ) * (doorSize.x/4) * -1
	global_position.y += (1-newScale.y ) * (doorSize.y/4) * -1
func Open():

	$AnimationPlayer.play("Open")
