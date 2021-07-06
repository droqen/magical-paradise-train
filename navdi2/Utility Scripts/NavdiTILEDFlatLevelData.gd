class_name FlatLevelData

var _map_width: int
var _tiles: PoolIntArray
var _tileset_id = null
var objects: Array = []
func _init(tileArray: PoolIntArray, map_width, tileset_id = null, _objects = []):
	self._tiles = tileArray
	self._map_width = map_width
	self._tileset_id = tileset_id
	self.objects = _objects
func get_width():
	return _map_width
func get_area():
	return _tiles.size()
func map_set_cells(tilemap):
	var x = 0
	var y = 0
	for tile in _tiles:
		if tile > 1:
			tilemap.set_cell(x, y, tile - 1)
		x += 1
		if x >= _map_width:
			x = 0
			y += 1
func get_cell(x, y): # doesn't check for illegal coordinates
	return _tiles[x + y * _map_width]
