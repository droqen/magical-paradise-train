extends Node2D



var currentDoorIndex = 0



func _ready():
	$Timer.connect("timeout",self,"OnTimeout")
	$Timer.start()
	
	var doorCount = $Doors.get_child_count()
	var newScale = Vector2(1,1)
	for d in doorCount:
		print(d)
		var door = $Doors.get_child(d)
		door.z_index = doorCount - d
		door.SetScale(newScale)
		newScale = newScale * 0.5
		
	
	
func OnTimeout():
	if currentDoorIndex < $Doors.get_child_count():
		var door = $Doors.get_child(currentDoorIndex)
	
		door.Open()
		currentDoorIndex += 1
	
