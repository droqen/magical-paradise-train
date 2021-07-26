extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered",self,"OnBodyEnter")


func OnBodyEnter(_body):
	get_parent().emit_signal("player_won")
