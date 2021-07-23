extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(float) var fadeDelay
export(float) var fadeSpeed
var timer=0.0
var tween
# Called when the node enters the scene tree for the first time.
func _ready():
	
	tween=get_node("Tween")
	tween.interpolate_property(self,"scale",Vector2(.274,.279),Vector2(.374,.379),tween.TRANS_BOUNCE,tween.EASE_IN_OUT)
	tween.start()
	$CPUParticles2D.emitting=true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(timer>fadeDelay):
		modulate.a-=fadeSpeed*delta
		modulate.a=clamp(modulate.a,0,255)
		$CPUParticles2D.emitting=false
	else:
		timer+=delta
	pass
