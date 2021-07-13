extends KinematicBody2D


var moveDir : Vector2 = Vector2.RIGHT
var moveSpeed : float = 20

export var isLocomotive : bool = false

func _ready():
	SetSprite()


func SetSprite():
	if isLocomotive:
		$Sprite.texture = load("res://Gabe/TrolleyProblem/locomotive.png")

func _physics_process(delta):
	move_and_slide(moveDir * moveSpeed)
