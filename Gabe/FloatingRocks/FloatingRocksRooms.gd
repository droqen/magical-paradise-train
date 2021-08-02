extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var _err
	_err = $TopLeft.connect("body_entered",self,"TopLeftEntered")
	_err = $TopRight.connect("body_entered",self,"TopRightEntered")
	_err = $BottomLeft.connect("body_entered",self,"BotLeftEntered")
	_err = $BottomRight.connect("body_entered",self,"BotRightEntered")
	_err = $StartRoom.connect("body_entered",self,"StartEntered")
	
	StartEntered(null)

func StartEntered(_body):
	$Camera2D.global_position = $StartRoom.global_position

func TopLeftEntered(_body):
	$Camera2D.global_position = $TopLeft.global_position
	
	
func TopRightEntered(_body):
	$Camera2D.global_position =$TopRight.global_position
	

func BotLeftEntered(_body):
	$Camera2D.global_position = $BottomLeft.global_position
	

func BotRightEntered(_body):
	$Camera2D.global_position = $BottomRight.global_position
