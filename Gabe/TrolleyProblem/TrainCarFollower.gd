extends KinematicBody2D

var trainFront 

var moveDir : Vector2 = Vector2.RIGHT
var moveSpeed : float = 10
var originalMoveSpeed : float = 10

var distanceToFront : float = 0

var currentPoint
var minDistance = 1

var isLocomotive : bool = false

func _ready():
	print("follower spawned")
	
func SetTrainFront(front):
	trainFront = front
	distanceToFront = global_position.distance_to(trainFront.global_position)
	
func SetAsLocomotive():
	isLocomotive = true
	
	$Sprite.texture = load("res://Gabe/TrolleyProblem/locomotive.png")

func _physics_process(delta):
	var dist =  global_position.distance_to(trainFront.global_position)
	if dist > distanceToFront:
		moveSpeed += .5
	if dist < distanceToFront:
		moveSpeed += -.5
	if dist - distanceToFront < 1:
		moveSpeed = originalMoveSpeed
		
	
	if currentPoint != null:
		moveDir = global_position.direction_to(currentPoint.global_position)
	
	
		var _vel = move_and_slide(moveDir * moveSpeed)
		
		if global_position.distance_to(currentPoint.global_position) < minDistance:
			if currentPoint.get_child_count() > 0:
				currentPoint = currentPoint.get_child(0)
			else:
				moveDir = Vector2.RIGHT
		
	look_at(trainFront.global_position)
