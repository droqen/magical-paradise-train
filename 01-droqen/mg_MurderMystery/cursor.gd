extends NavdiMazeNobody

onready var ncf = $"../NavdiCursorFollower"
onready var nbtm = $"../NavdiBoardTileMap"

func _ready():
	setup(nbtm, nbtm.world_to_map(ncf.position))
func _process(delta):
	_set_cell(maze.world_to_map(ncf.position))
	position += vector_to_center()*0.5
