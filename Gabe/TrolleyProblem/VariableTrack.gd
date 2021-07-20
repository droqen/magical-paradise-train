extends Node2D


var trackStates = ["straight", "bend"]
var trackState : int = 0

var sounds = [
	"res://Gabe/TrolleyProblem/sfx/SwitchFlipsOn_moreBass.wav",
	"res://Gabe/TrolleyProblem/sfx/SwitchFlipsOff_moreBass.wav"
]

var straightSpriteRectY = 0
var bendSpriteRectY = 22

var tween : Tween



func _ready():
	tween = Tween.new()
	add_child(tween)
	UpdateTrack()
	


func _input(event):
	if Input.is_key_pressed(KEY_0):
		
		IncrementTrackState()

func IncrementTrackState():
	trackState += 1
	
	if trackState > trackStates.size() -1:
		trackState = 0
	UpdateTrack()
	PlaySound()

	

func UpdateTrack():
	

	
	match(trackStates[trackState]):
		#TODO - fix tween not showing up right
		("straight"):
			var _val = tween.interpolate_method(self, "SetRegionRectY",
		bendSpriteRectY, straightSpriteRectY, .25,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
			var _s = tween.start()
			
		("bend"):
			var _val = tween.interpolate_method(self, "SetRegionRectY",
		$Sprite.get_rect().position.y, bendSpriteRectY, .25,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
			var _s = tween.start()
		

func SetRegionRectY(val : float):

	var r = Rect2(0,val,16,20)
	$Sprite.region_rect = r
	
func PlaySound():
	$AudioStreamPlayer.stream = load(sounds[trackState])
	$AudioStreamPlayer.play()
