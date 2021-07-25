extends Node2D


var currentGroupIndex = 0


func _ready():
	
	call_deferred("BirdGroupSetup")

func BirdGroupSetup():
	var birdGroups = get_children()
	for b in birdGroups:
		if b.has_method("IsBirdGroup"):
			var _err = b.connect("BIRDS_SCARED",self,"AdvanceBirds")
		
		
		if b.groupIndex == 0:
			b.SetActive()
		else:	
			b.SetInactive()
	
	


func AdvanceBirds():
	currentGroupIndex += 1
	
	var nextGroup = null
	var birdGroups = get_children()
	for b in birdGroups:
		if b.groupIndex == currentGroupIndex:
			nextGroup = b


	if nextGroup != null:
		nextGroup.SetActive()
	else:
		BirdsComplete()
	
	
func BirdsComplete():
	pass
	
