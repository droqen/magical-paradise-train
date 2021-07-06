extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(Array,int)var idl_frames
export(Array,int)var run_frames
export(Array,int)var air_up_frames
export(Array,int)var air_nl_frames
export(Array,int)var air_dn_frames

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
	
	var pin = $NavdiPinQuickPlayer
	pin.process_pins()
	
	if is_on_floor(): floorbuf = 3
	elif floorbuf > 0: floorbuf -= 1
	if (pin.a.just_pressed or pin.up.just_pressed) and floorbuf>0:
		velocity.y=-40-12*power
		floorbuf=0
	velocity.y+=100*delta
	velocity.x=_tow(velocity.x,30*pin.dpad.x,200*delta)
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
