extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(float) var accel
export(float) var deAccel
export(float) var maxSpeed
export(float) var angleLimit
export(float) var distanceLimit
export(bool) var rat
export(float) var rotateMult
export(float) var rotateMax
export(float) var sinAmp
export(float) var sinFreq
export(Array, Texture) var randomVariants
var fan
var theFloor
var time=0
var shadow
var shadowOffset
var audioComp
# Called when the node enters the scene tree for the first time.
func _ready():
	fan = get_parent().get_node("NavdiCursorFollower").get_child(0) 
	audioComp = get_parent().get_node("bumpSounds")
	
	shadow = get_node("Node/shadow")
	shadowOffset=Vector2(0,28.5)
	randomize()
	time=rand_range(0,2) #to vary the sin waves
	
	if(!rat):
		var randIndex=randi()%randomVariants.size()
		get_node("Sprite").texture=randomVariants[randIndex]
		shadow.texture=randomVariants[randIndex]
	
	pass # Replace with function body.

#other things to factor in: how close you r 2 fan, 
#how close the angle is to fan front (fan will just rotate to face center of screen)
func _physics_process(delta):
	if Input.is_action_pressed("left mouse button"):
		
		var angleToFan=(position-fan.get_parent().position)
		var distanceToFan=angleToFan.length()
		angleToFan=angleToFan.normalized()
		var angleInDegrees=abs(rad2deg( angleToFan.angle_to(fan.vectorToTarget)))
		
		
		if angleInDegrees<=angleLimit and distanceToFan<=distanceLimit:
			var distanceFactor=clamp( 1-distanceToFan/distanceLimit,0,1)
			var angleFactor = clamp( 1-angleInDegrees/angleLimit,0,1)
			linear_velocity+= (angleToFan*accel)*delta*distanceFactor*angleFactor
			if linear_velocity.length() >maxSpeed:
				 linear_velocity=linear_velocity.normalized()*maxSpeed
	
	linear_velocity= linear_velocity.move_toward(Vector2(0,0),deAccel*delta)
	
#	move_and_slide(linear_velocity)
#	var colData =  move_and_collide(linear_velocity.normalized()*5,true,true,true)
#	if colData!=null:
#		linear_velocity=(linear_velocity.reflect(colData.normal)*bounceMult)#+(colData.collider_linear_velocity*bounceMult)
	
	
	rotate((linear_velocity.length()*sign(linear_velocity.x))*delta*rotateMult)
	rotation_degrees = clamp(rotation_degrees,-rotateMax,rotateMax)
	
	time+=delta
	linear_velocity+=Vector2(0,1)* sin(time*sinFreq)*sinAmp
	
	
	#sort by y
	z_index=position.y
	#update shadow (why am i doing so much work for these shadows that you
	#can barely see
	shadow.position=global_position+shadowOffset
	shadow.rotation_degrees=rotation_degrees
	pass

var stillTouching
func _on_body_entered(body):
	if !audioComp.playing and !stillTouching && linear_velocity.length()>13:
		audioComp.pitch_scale=rand_range(0.8,1.2)
		audioComp.volume_db=linear2db(.5)
		audioComp.play()
		stillTouching=true
	pass # Replace with function body.


func _on_body_exited(body):
	stillTouching=false
	pass # Replace with function body.
