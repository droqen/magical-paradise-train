extends Node2D
export(Texture) var scratchTexture
export(Texture) var scratchTargets
export(Texture) var particleTarget
export(Texture) var scratchMaskTexture
export(Color) var overflowColor
export(Color) var missingColor
export(Color) var scratchColor
export(NodePath) var differencePath
export(float) var timeAfterLoss

signal end_gameplay(score)

onready var scratchMaskImage = scratchMaskTexture.get_data()
onready var scracthTargetImages = scratchTargets.get_data()
onready var differenceNode = get_node(differencePath)
var differenceImage : Image

var instructions: String

var line2d
var line2dParent

var game_started = false
var previous_pencil_position
var pencil_speed = Vector2.ZERO
var drawing = false
var can_draw = true
var was_drawing = false
var current_line
var points = 0
var volume = 0.0

var scracthTarget
var randomizedImageNumber
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var particles : CPUParticles2D = $pencil/pencil/particles
onready var particlesImage : Image = particleTarget.get_data()

# Called when the node enters the scene tree for the first time.
func _ready():
	line2d = get_node("../Viewport/Line2D")
	randomize()
	instructions = "scratch-a-"
	randomizedImageNumber = randi()%10 #TODO: make this be an array 
	#var prize = names[randomizedImageNumber]
	#instructions += prize
	$ScratchPrize.frame = randomizedImageNumber
	#	print(instructions)
	# $Instructions.text = instructions
	previous_pencil_position = get_global_mouse_position()*0.5
	particlesImage.lock()
	scracthTargetImages.lock() 

	differenceImage = Image.new()
	differenceImage.create(160,160,false,Image.FORMAT_RGBA8)
	differenceImage.fill(Color(0, 0,0 ,0))
	var t = ImageTexture.new()
	t.create_from_image(differenceImage)
	differenceNode.set_texture(t)
	
	scratchMaskImage.lock()
	
func _on_Timer_timeout():
	#score_and_end()
	pass

func score_and_end():
	compare_scratch()
	#yield(get_tree().create_timer(2.0), "timeout")
	#get_parent().emit_signal("player_won")

func compare_scratch():
	differenceImage = Image.new()
	differenceImage.create(160,160,false,Image.FORMAT_RGBA8)
	# differenceImage.fill(Color(0.2,1,0,0.8))

	differenceImage.lock()
	var scratchImage = scratchTexture.get_data()
	scratchImage.lock()
	var score = 0
	for i in range(160): 
		for j in range(160): 
			if scratchMaskImage.get_pixel(i, j).a == 0:
				continue
			var comp_offset_x = i + randomizedImageNumber * 160
			var color_scratch = scratchImage.get_pixel(i, j)
			var color_target = scracthTargetImages.get_pixel(comp_offset_x, j)

			# differenceImage.set_pixel(i, j, Color.cyan)
			# if(color_target.a > 0):
				# differenceImage.set_pixel(i, j, Color.blue)
			# if(color_scratch.a > 0):
				# differenceImage.set_pixel(i, j, Color.yellow)
			if abs(color_scratch.a - color_target.a) > 0.9:
				if color_target.a > 0.9:
					differenceImage.set_pixel(i, j, missingColor)
					# score -= 1
				if color_scratch.a > 0.9:
					differenceImage.set_pixel(i, j, overflowColor)
					score -= 1
			elif color_scratch.a > 0:
				score += 2

	emit_signal("end_gameplay", score)
	print("sending end gameplay singal")

	scratchImage.unlock()
	differenceImage.unlock()
	var t = ImageTexture.new()
	t.create_from_image(differenceImage)
	differenceNode.set_texture(t)
	
	$AudioStreamPlayer.volume_db = linear2db(0)


func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_SPACE:
			compare_scratch()

# Called every frame. 'delta' is the elapsed time since the previous frame.
var has_started = false
func _process(delta):
	var pencil_delta = $pencil.global_position-previous_pencil_position
	if Input.is_action_pressed("left mouse button") and can_draw and game_started and not game_ended:
		if(!has_started):
			has_started = true
			$BombTimer.start()
			#$Timer.start()
		particles.emitting = true
		$pencil/pencil.position.y = 30
		if was_drawing:
			volume = lerp(volume, pencil_speed.length()/100, delta*10)
		if not was_drawing:
			var new_line = line2d.duplicate()
			line2d.get_parent().add_child(new_line)
			#add_child(new_line)			
			current_line = new_line
			# if we want it to immediately scratch
			#current_line.add_point($pencil.position - Vector2(0, 0.1))
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
		particles.emitting = false
	$"pencil shadow".global_position = $pencil.global_position
	$AudioStreamPlayer.volume_db = linear2db(volume)
	if delta != 0:
		pencil_speed = lerp(pencil_speed, pencil_delta/delta, delta*5)
#		print(pencil_delta)
		$pencil/pencil.rotation_degrees = 30 + pencil_speed.x*0.1
		particles.direction = -pencil_delta.normalized()
		if(particles.global_position.x > 0 && particles.global_position.x < 160 && particles.global_position.y > 0 && particles.global_position.y < 160):
			var underColor = particlesImage.get_pixelv(particles.global_position)
			if underColor == scratchColor:
				particles.emitting = false
		else:
			particles.emitting = false
		$pencil.scale.x = pow(1.1, pencil_speed.y*0.01)
		$pencil.scale.y = 1/$pencil.scale.x
		var _x = sin($pencil/pencil.global_rotation)*$pencil.scale.x
		$"pencil shadow".scale.y = _x	
	
		
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

var game_ended = false
func _on_BombTimer_bomb_exploded():
	game_ended = true
	score_and_end()
	pass # Replace with function body.


func _on_Instructions_start_game():
	game_started = true
