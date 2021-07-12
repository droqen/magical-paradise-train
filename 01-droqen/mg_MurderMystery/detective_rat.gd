extends NavdiMazeNobody

signal touched(interestingTarget)

onready var curs = $"../cursor"
var prefer_xmove = true

enum { XAXIS, YAXIS }

var target_door_name
func setup(maze, cell):
	if target_door_name:
		if $"../State".has_node(target_door_name):
			var target_door = $"../State".get_node(target_door_name)
			cell = maze.world_to_map(target_door.position)
		target_door_name = null
		.setup(maze, cell)
		for dir in [Vector2.UP,Vector2.DOWN,
			Vector2.LEFT if $NavdiSheetSprite.flip_h else Vector2.RIGHT,
			Vector2.RIGHT if $NavdiSheetSprite.flip_h else Vector2.LEFT,
		]:
			if try_move(dir): break
		return self
	else:
		return .setup(maze, cell)

func _ready():
	setup($"../State/NavdiBoardTileMap", 
		$"../State/NavdiBoardTileMap".world_to_map(position))
func _process(delta):
	var to_curs = curs._cell - _cell
	if vector_to_center().length_squared() > 1:
		position += vector_to_center() * 0.4
	else:
		position += vector_to_center()
		if to_curs:
			var axes = [XAXIS,YAXIS]
			if abs(to_curs.y) > abs(to_curs.x):
				axes = [YAXIS,XAXIS]
			elif abs(to_curs.y) == abs(to_curs.x):
				if not prefer_xmove: axes = [YAXIS,XAXIS]
			prefer_xmove = axes[0] != XAXIS
			for axis in axes:
				if axis==XAXIS: if abs(to_curs.x):
					if try_move(Vector2.RIGHT*sign(to_curs.x)): break
				if axis==YAXIS: if abs(to_curs.y):
					if try_move(Vector2.DOWN*sign(to_curs.y)): break
		if not vector_to_center():
			if $NavdiSheetSprite.ani < 1:
				$NavdiSheetSprite.ani = 0
func cancel_cursor():
	if not curs:
		yield(get_tree(),"idle_frame")
		yield(get_tree(),"idle_frame")
	if not curs:
		return
	curs._set_cell(_cell)
	curs.locked_until_next_press = true
	curs.ncf.just_pressed = false
func try_move(move):
	if move.x: $NavdiSheetSprite.flip_h = move.x < 0
	if .try_move(move):
		return true
	else:
		var target_cell = _cell + move
		if target_cell == curs._cell:
			for child in maze.get_registered(target_cell):
				if child.get('IsInterest'):
					touch(child)
					return false
		return false
func is_move_legal(_from, _to) -> bool:
	if maze.get_cellv_flag(_to) == NavdiBoardTileMap.Flag.SolidWall: return false
	for child in maze.get_registered(_to): if child.get('IsSolid'): return false
	
	return true

func touch(interestingTarget):
	emit_signal("touched", interestingTarget)
