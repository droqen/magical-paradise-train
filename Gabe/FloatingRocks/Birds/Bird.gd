extends Node2D

enum BIRD_STATE {IDLE, FLY}
var currentState : int = 0
var speedScaleVariance = .15

var leaveDir : Vector2 = Vector2.ZERO
var moveDir : Vector2 = Vector2.ZERO
var moveSpeed = 80

var speedTween : Tween
var dirTween : Tween

func _ready():
	
	speedTween = Tween.new()
	add_child(speedTween)
	
	dirTween = Tween.new()
	add_child(dirTween)

	SetState(BIRD_STATE.IDLE)
	
	var _err = $Area2D.connect("area_entered",self,"AreaEntered")

func _physics_process(delta):
	match(currentState):
		(BIRD_STATE.FLY):
			global_position = global_position + moveDir * moveSpeed * delta
			if moveDir.x > 0:
				$AnimatedSprite.flip_h = true
			else:
				$AnimatedSprite.flip_h = false
func FaceRandomDirection():
		var ran = randf()
		if ran > 0.5:
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
			
func GetScared(newLeaveDir : Vector2):
	SetState(BIRD_STATE.FLY)
	leaveDir = newLeaveDir
	
	###TODODODODO
	moveDir = leaveDir
	
	
func SetState(newState : int):
	currentState = newState
	
	match(currentState):
		(BIRD_STATE.IDLE):
			$AnimatedSprite.play("IDLE")
			
			var ran = rand_range(-speedScaleVariance,speedScaleVariance)
			$AnimatedSprite.speed_scale = 0.25 + ran
			FaceRandomDirection()
			
		(BIRD_STATE.FLY):
			$AnimatedSprite.play("FLY")
			$AnimatedSprite.speed_scale = 2
			
func AreaEntered(_area):
	if currentState == BIRD_STATE.FLY:
		$DestroyTimer.start()

