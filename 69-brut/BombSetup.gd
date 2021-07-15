extends Tween
onready var sprite = $Sprite
onready var rope = $rope
onready var explosion = get_node("rope/Sprite")

onready var rope_end_pos : Vector2 = rope.position
var start_pos = 190


# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.scale = Vector2.ZERO
	rope.position = Vector2(start_pos, rope.position.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("ui_select")):
		do_the_tween()
	

var initialPos : Vector2
func do_the_tween():
	rope.position = Vector2(180, rope.position.y)
	interpolate_property(sprite, "scale", 
		Vector2.ZERO, Vector2(0.75,0.75), 0.325, 
		TRANS_BACK, EASE_OUT)
	interpolate_property(sprite, "rotation_degrees",
		0, -390, 0.3, TRANS_BACK, EASE_OUT) 
		
	initialPos = rope.position
	interpolate_property(rope, "position", rope.position, rope_end_pos, 0.3, TRANS_BACK, EASE_OUT)
	start()
	


func _on_BombSetup_tween_completed(object, key):
	if(object == rope):
		print("Lololo")
		interpolate_property(explosion, "scale", Vector2.ZERO, Vector2.ONE*0.8, 3, TRANS_BACK, EASE_OUT)
		#rope.position.x = 150
		rope.itscomminghome(start_pos)
		interpolate_property(rope, "position", rope.position, initialPos, 6, TRANS_BACK, EASE_OUT)
		start()
