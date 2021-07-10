extends NavdiMazeNobody

onready var ncf = $"../NavdiCursorFollower"
onready var nbtm = $"../NavdiBoardTileMap"

var nudged: Vector2
var nudge_frames: int = 0
var interest:bool = false
var was_interest:bool = false

func _ready():
	setup(nbtm, nbtm.world_to_map(ncf.position))
	
func is_cell_interesting(cell):
	for child in maze.get_registered(cell):
		if child.get('IsInterest'): return true
	
func _process(delta):
	var target_cell = maze.world_to_map(ncf.position)
	if (target_cell != _cell
	and ncf.position.distance_squared_to(position) < 8*8
	and not is_cell_interesting(target_cell)):
		if ncf.pressed:
			$NavdiSheetSprite.position.x = target_cell.x - _cell.x
			$NavdiSheetSprite.position.y = target_cell.y - _cell.y
			nudge_frames = 3
		target_cell = _cell
	
	_set_cell(target_cell)
	var move = vector_to_center()
	if move:
		if move.x: $NavdiSheetSprite.position.x = -sign(move.x)*1
		if move.y: $NavdiSheetSprite.position.y = -sign(move.y)*1
		if move.length_squared()>8:
			position += move * 0.75
		else:
			position += move
		nudge_frames = 3
func _physics_process(_delta):
	if nudge_frames > 0:
		nudge_frames -= 1
		if nudge_frames <= 0:
			$NavdiSheetSprite.position = Vector2.ZERO
			was_interest = false # cleared
	_update_sprite()
func _set_cell(cell):
	._set_cell(cell)
	was_interest = interest
	interest = false
	for child in maze.get_registered(cell):
		if child.get('IsInterest'):
			interest = true
			break
	_update_sprite()

func _update_sprite():
	if interest: $NavdiSheetSprite.frames = [22]
	else: $NavdiSheetSprite.frames = [23]
