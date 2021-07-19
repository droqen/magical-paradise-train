extends Node2D
#8 directional sprite that faces a target

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var vectorToTarget
export(String) var targetName
var target
var animSprite
var particleThing
# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_node(targetName) 
	animSprite= get_node("AnimatedSprite")
	particleThing = get_node("Particles2D")
	pass # Replace with function body.


#tracks the direction to the target and swaps sprites based on that
func _process(delta):
	
	
	if Input.is_action_just_pressed("left mouse button"):
		particleThing.emitting=true
		#also sound on
	if Input.is_action_just_released("left mouse button"):
		particleThing.emitting=false
		#also sound off
	
	
	vectorToTarget=(target.global_position-global_position).normalized()
	
	var angleDegrees=rad2deg( vectorToTarget.angle())
	
	if angleDegrees<22.5 and angleDegrees>=-22.5:
		animSprite.animation="right"
		particleThing.direction= Vector2.RIGHT
	elif angleDegrees<67.5 and angleDegrees>=22.5:
		animSprite.animation="downRight"
		particleThing.direction= Vector2(1,1)
	elif angleDegrees<112.5 and angleDegrees>=67.5:
		animSprite.animation="down"
		particleThing.direction= Vector2.DOWN
	elif angleDegrees<157.5 and angleDegrees>=112.5:
		animSprite.animation="downLeft"
		particleThing.direction= Vector2(-1,1)
	elif angleDegrees<-22.5 and angleDegrees>=-67.5:
		animSprite.animation="upRight"
		particleThing.direction= Vector2(1,-1)
	elif angleDegrees<-67.5 and angleDegrees>=-112.5:
		animSprite.animation="up"
		particleThing.direction= Vector2.UP
	elif angleDegrees<-112.5 and angleDegrees>=-157.5:
		animSprite.animation="upLeft"
		particleThing.direction= Vector2(-1,-1)
	else:
		animSprite.animation="left"
		particleThing.direction= Vector2.LEFT
	
	pass
