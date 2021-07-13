extends Area2D

export var newDir = Vector2.UP

func _ready():
	var _err = connect("body_entered",self,"ChangeTrainDir")

func ChangeTrainDir(body):
	body.moveDir = newDir
	
