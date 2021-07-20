extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var _err = connect("pressed",self,"OnPressed")


func OnPressed():
	get_parent().emit_signal("player_won")
