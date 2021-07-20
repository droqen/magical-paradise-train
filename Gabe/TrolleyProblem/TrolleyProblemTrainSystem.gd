extends Node2D


onready var path = $Path

func _ready():
	call_deferred("SetStartPoint")


func SetStartPoint():
	var startPoint = $Path/Start
	
	var children = $Train.get_children()
	for c in children:
		c.currentPoint = startPoint
