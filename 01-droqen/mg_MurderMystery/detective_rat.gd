extends NavdiMazeNobody

onready var nbtm = $"../NavdiBoardTileMap"
onready var curs = $"../cursor"
var prefer_xmove = true

enum { XAXIS, YAXIS }

func _ready():
	setup(nbtm, nbtm.world_to_map(position))
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
	curs._set_cell(_cell)
func try_move(move):
	if move.x: $NavdiSheetSprite.flip_h = move.x < 0
	return .try_move(move)
func is_move_legal(_from, _to) -> bool:
	if maze.get_cellv_flag(_to) == NavdiBoardTileMap.Flag.SolidWall: return false
	for child in maze.get_registered(_to): if child.get('IsSolid'): return false
	
	return true
