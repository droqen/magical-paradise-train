extends KinematicBody2D

export(Array,int)var idl_frames
export(Array,int)var run_frames
export(Array,int)var slide_frames # TODO: update with new art

var velocity:Vector2=Vector2.ZERO
var to_next:float=0
var cell:Vector2
var visual_offset:Vector2=Vector2.ZERO
onready var map=$"../State/NavdiBoardTileMap"
onready var generator=$"../Generator"

func _ready():
	cell=map.world_to_map(position)
	map._register(cell,self)

func _tow(a,b,rate):
	if a+rate<b:return a+rate
	if a-rate>b:return a-rate
	return b
	
# returns whether the offset is back at zero
func update_visual_offset():
	visual_offset.x=_tow(visual_offset.x,0,1)
	visual_offset.y=_tow(visual_offset.y,0,1)
	return visual_offset.x==0 and visual_offset.y==0
	
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
		
	if update_visual_offset():
		var pin = $NavdiPinQuickPlayer
		pin.process_pins()

		var dir=Vector2.ZERO
		var mytile=map.get_cellv(cell)
		var nodes=map.get_registered(cell)
		if $"../cheese" in nodes:
			$get.play()
			to_next = 0.1
#		elif mytile==generator.WIN_TILE:
#			$get.play()
#			to_next = 0.1
		elif mytile==generator.ICE_TILE and (velocity.x!=0 or velocity.y!=0):
			dir=velocity
			$NavdiSheetSprite.frames = slide_frames
		else:
			var has_input=true
			if pin.left.held:
				dir=Vector2.LEFT
				$NavdiSheetSprite.flip_h = true
			elif pin.right.held:
				dir=Vector2.RIGHT
				$NavdiSheetSprite.flip_h = false
			elif pin.up.held:
				dir=Vector2.UP
			elif pin.down.held:
				dir=Vector2.DOWN
			else:
				has_input=false
			if has_input:
				velocity=dir
				$NavdiSheetSprite.frames = run_frames
			else:
				$NavdiSheetSprite.frames = idl_frames
		var next_cell=cell+dir
		var do_move=false
		if map.get_cellv(next_cell) != generator.WALL_TILE:
			do_move=true
		
		if do_move:
			visual_offset.x=-map.cell_size.x*dir.x
			visual_offset.y=-map.cell_size.y*dir.y
			map._unregister(cell,self)
			cell=next_cell
			map._register(cell,self)
		else:
			visual_offset.x=0.25*map.cell_size.x*dir.x
			visual_offset.y=0.25*map.cell_size.y*dir.y
			velocity=Vector2.ZERO
	position=map.map_to_center(cell)+visual_offset
	
