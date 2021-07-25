extends Node2D

var active : bool = false
export var groupIndex = 0


func _ready():
	var _err = $Area2D.connect("body_entered",self,"OnEnter")
	SetActive()
	
func SetActive():
	print(name + "set active")
	active = true
	show()
	
	
	
func SetInactive():
	print(name + "set inactive")
	active = false
	hide()
	
	
	
func OnEnter(_body):
	if active:
		_body.AcquireBird()
		queue_free()

