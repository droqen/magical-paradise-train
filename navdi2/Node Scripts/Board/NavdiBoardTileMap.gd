tool
extends TileMap
class_name NavdiBoardTileMap

export(bool)var refresh_tileset = true

enum Flag {
	UNASSIGNED = -1,
	Floor = 0,
	SolidWall = 1,
	OneWayWall = 13,
	SpawnObject = 2,
	ILLEGALTile = 10,
	DefaultFloor = 20,
}

func _ready():
	self.cell_y_sort = true

var registeredNodes = LumpyDictionary.new()

func _register(cell, node): registeredNodes.lump_add(cell, node)
func _unregister(cell, node): registeredNodes.lump_remove(cell, node)
func get_registered(cell): return registeredNodes.lump_get_all(cell)

func get_default_floor_tile():
	for tid in tile_set.get_tiles_ids():
		if tile_set.values_to_flags[tid] == Flag.DefaultFloor:
			return tid
	return 0

func map_to_center(cell):
	return .map_to_world(cell) + cell_size * 0.5

func get_cellv_flag(cell):
	return tile_set.values_to_flags[get_cellv(cell)]

func _process(_delta):
	if refresh_tileset and tile_set:
		refresh_tileset = false
		if tile_set.get('cell_size'):
			cell_size = tile_set.cell_size
