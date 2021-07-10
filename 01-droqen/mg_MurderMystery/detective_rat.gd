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
func try_move(dir):
	if .try_move(dir):
		print(dir)
		return true
