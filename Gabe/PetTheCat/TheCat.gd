extends Node2D

var currentPets : int = 0
var maxPets : int = 6

var buttMoveAmount : Vector2 = Vector2(-1,-3)/10
#var buttMoveDelta : Vector2 = Vector2(-1,-3)

var tailRotationAmount : float = 20

var canPet : bool = false

var catTween : Tween



func _ready():
	$ClosedEyes.show()
	var _err = $StartTimer.connect("timeout",self,"OnStartTimeout")

	catTween = Tween.new()
	add_child(catTween)

func OnStartTimeout():
	
	$ClosedEyes.hide()
	
	
func OnGameStart():
	canPet = true


func MoveCatButt(moveAmount):
	$CatTop.global_position += moveAmount
	$CatBodyPolygon2D.ShiftPoints(moveAmount)
	


func OnCatPet(_area):
	if !canPet: 
		return
		
	if catTween.is_active():
		return
	
	catTween.interpolate_method(self, "MoveCatButt",
		Vector2.ZERO, buttMoveAmount, .25,
		Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	catTween.start()
	
	
	
	$CatTop/CatTail.rotation_degrees += tailRotationAmount
	currentPets += 1
	$CatSounds.PlayCatPurr()
	
	if currentPets >= maxPets:
		canPet = false
		get_parent().GameOver()
		$ClosedEyes.show()
