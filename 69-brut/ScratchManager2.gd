extends Node2D
var instructions: String
var rat_attributes = [
	" cool",
	" heroic",
	" punk",
	" cottagecore",
	" gay",
	" friendly",
	"n adorable",
	" round",
	"n anthro",
	" seductive",
	" skaterboy",
	"n abstract",
	" mad",
	" hyperrealistic",
	" dad",
	" baby",
	" soft",
	" square",
	" minecraft",
	" slimy",
	" hot",
	" comically large",
	" miniscule",
	" screen-filling",
	" funny",
	"n evil", 
	" twisted",
	" minimalist"
	
]

var line2d

var previous_pencil_position
var pencil_speed = Vector2.ZERO
var drawing = false
var can_draw = true
var was_drawing = false
var current_line
var points = 0
var volume = 0.0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	line2d = get_node("../Viewport/Line2D")
	randomize()
	instructions = "draw a"
	instructions += rat_attributes[randi()%rat_attributes.size()]
	instructions += " rat"
#	print(instructions)
	$Instructions.text = instructions
	previous_pencil_position = get_global_mouse_position()*0.5
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pencil_delta = $pencil.global_position-previous_pencil_position
	if Input.is_action_pressed("left mouse button") and can_draw:
		$pencil/pencil.position.y = 30
		volume = lerp(volume, pencil_speed.length()/100, delta*10)
		if not was_drawing:
			var new_line = line2d
			#add_child(new_line)
			current_line = new_line
		current_line.add_point($pencil.position)
#		points += 1
#		print(current_line.points)
		was_drawing = true
	else:
		$pencil/pencil.position.y = lerp($pencil/pencil.position.y, -10, delta*10) # mouse is not down
		volume = lerp(volume, 0.0, delta*10)
#		if was_drawing:
#			print(points)
		was_drawing = false
	$"pencil shadow".global_position = $pencil.global_position
	$AudioStreamPlayer.volume_db = linear2db(volume)
	if delta != 0:
		pencil_speed = lerp(pencil_speed, pencil_delta/delta, delta*5)
#		print(pencil_delta)
		$pencil/pencil.rotation_degrees = 30 + pencil_speed.x*0.1
		$pencil.scale.x = pow(1.1, pencil_speed.y*0.01)
		$pencil.scale.y = 1/$pencil.scale.x
		var _x = sin($pencil/pencil.global_rotation)*$pencil.scale.x
		$"pencil shadow".scale.y = _x
		print(_x)
	previous_pencil_position = $pencil.global_position
	pass


func _draw():
	pass
	#var view = get_node("../Viewport")
	#draw_texture(view.get_texture(), Vector2.ZERO)

func _on_NoDrawZone_area_entered(area):
	can_draw = false
	pass # Replace with function body.


func _on_NoDrawZone_area_exited(area):
	can_draw = true
	pass # Replace with function body.


func _on_Button_pressed():
	get_parent().emit_signal("player_won")
	$AudioStreamPlayer2.play()
	pass # Replace with function body.
