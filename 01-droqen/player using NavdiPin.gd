extends KinematicBody2D

# Looking for how to use the NavdiPinQuickPlayer node?
# Go to the _process function for THREE 'how to use'
# sections hidden in the comments of this script

export(Array,int)var idl_frames
export(Array,int)var run_frames
export(Array,int)var air_up_frames
export(Array,int)var air_nl_frames
export(Array,int)var air_dn_frames

var velocity:Vector2
var floorbuf:int
var power:int = 1
var to_next:float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if to_next > 0:
		to_next -= delta
		if to_next <= 0:
			get_parent().emit_signal("player_won")
			to_next = 100
		$NavdiSheetSprite.frames = run_frames
		$NavdiSheetSprite.rate = 10
		return
	
	# NavdiPinQuickPlayer - how to use
	var pin = $NavdiPinQuickPlayer
	pin.process_pins() # manually call this 1x/frame, before using it
	
	if is_on_floor(): floorbuf = 3
	elif floorbuf > 0: floorbuf -= 1
	
	# NavdiPinQuickPlayer - how to use
	# reading 'just_pressed' inputs
	# * pin.a is a 'PinSingle'
	# * pin.dpad_impulse is a Vector2 that is only nonzero for a frame
	if (pin.a.just_pressed or pin.dpad_impulse.y < 0) and floorbuf>0:
		velocity.y=-40-12*power
		floorbuf=0
	
	velocity.y+=100*delta
	velocity.x=_tow(velocity.x,30*pin.dpad.x,200*delta)
	
	# NavdiPinQuickPlayer - how to use
	# reading 'dpad'
	# * it's a Vector2 that flattens any analog into -1/0/1 values
	if pin.dpad.x:
		$NavdiSheetSprite.flip_h = pin.dpad.x < 0
	if floorbuf > 0:
		if pin.dpad.x:
			$NavdiSheetSprite.frames = run_frames
		else:
			$NavdiSheetSprite.frames = idl_frames
	elif velocity.y < -20:
		$NavdiSheetSprite.frames = air_up_frames
	elif velocity.y < 30:
		$NavdiSheetSprite.frames = air_nl_frames
	else:
		$NavdiSheetSprite.frames = air_dn_frames
	velocity=move_and_slide(velocity,Vector2.UP)
	
	var map = $"../State/NavdiBoardTileMap"
	var cell = map.world_to_map(position)
	if map.get_cellv(cell) == 9 and power <= 1:
#		map.set_cellv(cell, -1)
		power += 1
		$get.play()
		if power > 1:
			to_next = 0.1
	
func _tow(a,b,rate):
	if a+rate<b:return a+rate
	if a-rate>b:return a-rate
	return b
