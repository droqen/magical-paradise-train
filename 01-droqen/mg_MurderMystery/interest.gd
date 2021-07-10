extends NavdiMazeNobody

const IsSolid = true
const IsInterest = true

func _ready():
	var _tilemap = $"../NavdiBoardTileMap"
	setup(_tilemap, _tilemap.world_to_map(position))
