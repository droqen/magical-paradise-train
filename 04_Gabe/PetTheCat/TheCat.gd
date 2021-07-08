extends Node2D

var currentPets : int = 0
var maxPets : int = 6

var buttMoveAmount : Vector2 = Vector2(-1,-3)
var buttMoveDelta : Vector2 = Vector2(-1,-3)

var tailRotationAmount : float = 20

var canPet : bool = true


func _ready():
	pass 


func OnCatPet(_area):
	if !canPet: return
	
	$CatTop.global_position += buttMoveAmount
	$CatBodyPolygon2D.ShiftPoints(buttMoveAmount)
	buttMoveAmount += buttMoveDelta
	$CatTop/CatTail.rotation_degrees += tailRotationAmount
	currentPets += 1
	
	if currentPets >= maxPets:
		get_parent().GameOver()
