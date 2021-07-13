extends KinematicBody2D

var trainFront 

var moveDir : Vector2 = Vector2.RIGHT
var moveSpeed : float = 20

var isLocomotive : bool = false

func _ready():
	print("follower spawned")
	
func SetTrainFront(front):
	trainFront = front
	
func SetAsLocomotive():
	isLocomotive = true
	
	$Sprite.texture = load("res://Gabe/TrolleyProblem/locomotive.png")

func _physics_process(delta):
	move_and_slide(moveDir * moveSpeed)
	look_at(trainFront.global_position)
