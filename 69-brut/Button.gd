extends Button

export (Curve) var jiggle
var time_since_press = 0
var was_pressed = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if was_pressed:
		time_since_press += delta
		$"done button".scale.x = jiggle.interpolate(time_since_press)
		$"done button".scale.y = 1/jiggle.interpolate(time_since_press)
	pass


func _on_Button_pressed():
	was_pressed = true
	time_since_press = 0
	pass # Replace with function body.
