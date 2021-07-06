class_name TiledMap

var _tiles: PoolIntArray
var _map_width: int
var tsx_name: String
var objects: Array = []
func _init(tileArray: PoolIntArray, map_width, _tsx_name, _objects = []):
	self._tiles = tileArray
	self._map_width = map_width
	self.tsx_name = _tsx_name
	self.objects = _objects
func get_width() -> int:
	return _map_width
func get_area() -> int:
	return _tiles.size()
func get_height() -> int:
	# warning-ignore:integer_division
	return get_area() / get_width()
func get_size() -> Vector2:
	var w = get_width()
	return Vector2(w, get_area() / w)
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
