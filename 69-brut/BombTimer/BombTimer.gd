extends Tween
onready var sprite = $Sprite
onready var rope = $rope
onready var explosion = get_node("rope/fire")
export (float) var duration
signal bomb_exploded

onready var rope_end_pos : Vector2 = rope.position
var start_pos = 210

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.scale = Vector2.ZERO
	rope.position = Vector2(start_pos, rope.position.y)

var initialPos : Vector2
func start():
	rope.position = Vector2(180, rope.position.y)
	$SetupTween.interpolate_property(sprite, "scale", 
		Vector2.ZERO, Vector2(0.75,0.75), 0.325, 
		TRANS_BACK, EASE_OUT)
	$SetupTween.interpolate_property(sprite, "rotation_degrees",
		0, -390, 0.3, TRANS_BACK, EASE_OUT) 
	
	var initialSetupTime = 0.3
	var rope_duration = duration - $explosion.lifetime - initialSetupTime
		
	initialPos = rope.position
	$SetupTween.interpolate_property(rope, "position", rope.position, rope_end_pos, initialSetupTime, TRANS_BACK, EASE_OUT)
	$SetupTween.start()
	yield($SetupTween, "tween_completed")
	print("FSSHHHH")
	$SetupTween.interpolate_property(explosion, "scale", Vector2.ZERO, Vector2.ONE*0.8, 0.25, TRANS_BACK, EASE_OUT)
	$SetupTween.start()
	#rope.position.x = 150
	#$rope.set_on_fire(start_pos)
	print("ROPEROPE")
	$rope/RopeTween.interpolate_property($rope, "position", $rope.position, initialPos, rope_duration-0.1, TRANS_LINEAR, EASE_IN_OUT)
	$rope/RopeTween.start()
	#interpolate_property(rope, "position", rope.position, initialPos, duration, TRANS_BACK, EASE_OUT)
	yield($rope/RopeTween, "tween_completed")
	print("BOOOM")
	$explosion.emitting = true
	$Sprite.visible=false
	$rope.visible=false
	yield(get_tree().create_timer($explosion.lifetime), "timeout")
	emit_signal("bomb_exploded")
		
