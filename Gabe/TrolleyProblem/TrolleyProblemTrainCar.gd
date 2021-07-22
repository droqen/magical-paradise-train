extends KinematicBody2D



var moveSpeed : float = 10

var currentPoint : Node2D
var moveDir = Vector2.RIGHT

var minDistance = 1

export var isLocomotive : bool = false

var followerScene = "res://Gabe/TrolleyProblem/TrolleyProblemTrainCarFollower.tscn"

func _ready():
	call_deferred("SpawnFollower")
	
func SpawnFollower():
	var t = load(followerScene).instance()
	get_parent().add_child(t)
	t.SetTrainFront(self)
	t.moveSpeed = moveSpeed
	if isLocomotive:
		t.SetAsLocomotive()

	t.global_position = global_position + Vector2(-16,0)


func _physics_process(delta):
	
	if currentPoint != null:
		moveDir = global_position.direction_to(currentPoint.global_position)
	
	
		move_and_slide(moveDir * moveSpeed)
		
		if global_position.distance_to(currentPoint.global_position) < minDistance:
			if currentPoint.get_child_count() > 0:
				currentPoint = currentPoint.get_child(0)
			else:
				moveDir = Vector2.RIGHT
		
		
	
	
