extends Node2D


func _ready():
	pass


func SetFacing(dir : float):
	dir = sign(dir)
	if dir == -1:
		$AnimatedSprite.flip_h = true


	if dir == 1:
		$AnimatedSprite.flip_h = false



func SetAnim(inputVec, isOnGround, isOnWall, _isJump, isCrouch):
	if isOnGround:
		$AnimatedSprite.play("WALK")
		if inputVec.x == 0:
			$AnimatedSprite.speed_scale = 0
		else:
			$AnimatedSprite.speed_scale = 2
	elif isOnWall:
		$AnimatedSprite.play("CLIMB")
		if inputVec.y == 0:
			$AnimatedSprite.speed_scale = 0
		else:
			$AnimatedSprite.speed_scale = 1
	else:
		$AnimatedSprite.play("JUMP")
		
	#THIS IS NOT AN ELSE
	if isCrouch:
		$AnimatedSprite.play("CROUCH")
