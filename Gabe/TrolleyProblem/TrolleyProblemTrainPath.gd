extends Node2D

var trackStates = ["straight", "bend"]
var trackState : int = 0

var straightPos : Vector2 = Vector2.ZERO
var bendPos : Vector2 = Vector2(0,-48)

func _ready():
	pass # Replace with function body.
	
func IncrementTrackState():
	trackState += 1
	
	if trackState > trackStates.size() -1:
		trackState = 0
	UpdateTrack()
	
func UpdateTrack():
	match(trackStates[trackState]):
	
		("straight"):
			$Start/Node2D2/EndSegment.position = straightPos
			
		("bend"):
			$Start/Node2D2/EndSegment.position = bendPos
