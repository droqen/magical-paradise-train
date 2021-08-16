extends Sprite
var pos = 0.0
var speed = 0.0
var angle = 0.0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	speed = lerp(speed, -pos * 20, delta * 10)
	pos += speed * delta
	angle += delta * 10
	if angle > TAU:
		angle -= TAU
	
	scale.y = pow(1.25, pos + 0.15*sin(angle))
	scale.x = 1/scale.y
	scale *= 0.4
	pass
