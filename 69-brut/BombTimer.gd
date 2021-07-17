extends Tween
onready var sprite = $Sprite
onready var rope = $rope
onready var explosion = get_node("rope/fire")
export (float) var duration
signal bomb_exploded

onready var rope_end_pos : Vector2 = rope.position
var start_pos = 190


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
		
	initialPos = rope.position
	$SetupTween.interpolate_property(rope, "position", rope.position, rope_end_pos, 0.3, TRANS_BACK, EASE_OUT)
	$SetupTween.start()
	yield($SetupTween, "tween_completed")
	$SetupTween.interpolate_property(explosion, "scale", Vector2.ZERO, Vector2.ONE*0.8, 3, TRANS_BACK, EASE_OUT)
	$SetupTween.start()
	#rope.position.x = 150
	#$rope.set_on_fire(start_pos)
	$rope/RopeTween.interpolate_property($rope, "position", $rope.position, initialPos, duration, Tween.TRANS_BACK, Tween.EASE_OUT)
	$rope/RopeTween.start()
	#interpolate_property(rope, "position", rope.position, initialPos, duration, TRANS_BACK, EASE_OUT)
	yield($rope/RopeTween, "tween_completed")
	emit_signal("bomb_exploded")
		
