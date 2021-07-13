extends KinematicBody2D


var moveDir : Vector2 = Vector2.RIGHT
var moveSpeed : float = 20

export var isLocomotive : bool = false

var followerScene = "res://Gabe/TrolleyProblem/TrainCarFollower.tscn"

func _ready():
	call_deferred("SpawnFollower")
	
func SpawnFollower():
	var t = load(followerScene).instance()
	get_parent().add_child(t)
	t.SetTrainFront(self)
	if isLocomotive:
		t.SetAsLocomotive()

	t.global_position = global_position + Vector2(-32,0)


func _physics_process(delta):
	move_and_slide(moveDir * moveSpeed)
