extends Node2D

var texts = [
	"cool dude",
	"rad fella",
	"homie",
	"cute pal",
	"you :)",
	"alAJSKDL"
]

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize_polaroid()
	$AnimationPlayer.play("having your picture taken")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func randomize_polaroid():
	randomize()
	$"dude with a polaroid/Node2D/Polaroid".frame = randi()%5
	$"dude with a polaroid/Node2D/Polaroid/Label".text = texts[randi()%texts.size()]
	pass


