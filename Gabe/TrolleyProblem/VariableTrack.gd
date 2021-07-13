extends Node2D


var trackStates = ["straight", "bend"]
var trackState : int = 0


var straightSpriteRectY = 0
var bendSpriteRectY = 22

var tween : Tween

signal TRACK_ENTERED

func _ready():
	tween = Tween.new()
	add_child(tween)
	UpdateTrack()
	
	$TrainDirectionArea.connect("body_entered",self,"OnTrackEnter")

func _input(event):
	if Input.is_key_pressed(KEY_0):
		
		IncrementTrackState()

func IncrementTrackState():
	trackState += 1
	
	if trackState > trackStates.size() -1:
		trackState = 0
	UpdateTrack()


	

func UpdateTrack():
	print("rect y is: " +  str($Sprite.get_rect().position.y) )

	
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
	print(val)
	var r = Rect2(0,val,16,20)
	$Sprite.region_rect = r
	
	
func OnTrackEnter(_body):
	emit_signal("TRACK_ENTERED")
	print("entered")
