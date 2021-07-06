extends AStar2D
class_name NavdiBoardPathstar

var _tilemap:NavdiBoardTileMap
var _scheme = PointScheme.Disorganized
var _scheme_zonegrid_zone:TileZone

enum PointScheme {
	Disorganized = 0,
	ZoneGrid = 1,
}

const DefaultSolidFlagIds = [
	NavdiBoardTileMap.Flag.UNASSIGNED,
	NavdiBoardTileMap.Flag.ILLEGALTile,
	NavdiBoardTileMap.Flag.SolidWall,
	NavdiBoardTileMap.Flag.OneWayWall,
]

const OrthoDirs = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN, ]

func setup_from_tilemap(tilemap):
	self.clear()
	var usedrect = tilemap.get_used_rect()
	var usedzone = TileZone.new(usedrect.size, usedrect.position)
	self.reserve_space(usedzone.size.x * usedzone.size.y) # might as well, eh?
	self._scheme = PointScheme.ZoneGrid
	self._scheme_zonegrid_zone = usedzone
	
	for cell in usedzone.get_all_cells():
#		print("has func? ",tilemap.has_method("get_cellv_flag"))
		if tilemap.get_cellv_flag(cell) in DefaultSolidFlagIds:
			continue # obstacle or unassigned
		var point = zonegrid_cell_to_point(cell)
		add_point(point, cell)
		for dir in OrthoDirs:
			var ncell = cell + dir
			var npoint = zonegrid_cell_to_point(ncell)
			if npoint and has_point(npoint):
				connect_points(point, npoint, true)
	
	return self

func zonegrid_point_to_cell(point):
	if point != null: return Vector2(
		point % _scheme_zonegrid_zone.size.x, + 
		int(point / _scheme_zonegrid_zone.size.x)
	) + _scheme_zonegrid_zone.position

func zonegrid_cell_to_point(cell):
	if cell != null and _scheme_zonegrid_zone.has_point(cell):
		cell -= _scheme_zonegrid_zone.position
		return int(cell.x + _scheme_zonegrid_zone.size.x * cell.y)

#func _astar_add_walkable_cells():
#	var points_array = []
#	for y in range(_astar_map_size.y):
#		for x in range(_astar_map_size.x):
#			var point = Vector2(x, y)
#
#			if _astar_is_cellvalue_obstacle(get_cellv(point)):
#				continue # obstacle
#
#			points_array.append(point)
#			var point_index = _astar_calc_point_index(point)
#			_astar.add_point(point_index, point)
#	return points_array

#extends AStar
#class_name NavdiAStar
#
#func setup_from_tilemap(tilemap:TileMap):
#	var points_array = []
#	for y in range(_astar_map_size.y):
#		for x in range(_astar_map_size.x):
#			var point = Vector2(x, y)
#
#			if _astar_is_cellvalue_obstacle(get_cellv(point)):
#				continue # obstacle
#
#			points_array.append(point)
#			var point_index = _astar_calc_point_index(point)
#			_astar.add_point(point_index, point)
#	return points_array
#
#
#func astar_init(map_size: Vector2):
#	_astar = AStar2D.new()
#	_astar_map_size = map_size
#	astar_generate_cells()
#
#func astar_generate_cells():
#	_astar.clear()
#	var walkable_cells_list = _astar_add_walkable_cells()
#	_astar_connect_walkable_cells(walkable_cells_list)
#	_astar_points = _astar.get_points()
#	_astar_point_count = len(_astar_points)
#
#func astar_path(a, b):
#	if astar_exists(a) and astar_exists(b):
#		self._astar_start = a
#		self._astar_end = b
#		_astar_recalculate_path()
#		return _astar_point_path
#	else:
#		return null
#
#func astar_fill(point):
#	if astar_is_in_bounds(point):
#		var cellIds = [_astar.get_closest_point(point)]
#		var onCellId = 0
#		while onCellId < len(cellIds):
#			for connected_point in _astar.get_point_connections(cellIds[onCellId]):
#				if not cellIds.has(connected_point):
#					cellIds.append(connected_point)
#			onCellId += 1
#		var cells = []
#		for cellId in cellIds:
#			var cellPos = _astar.get_point_position(cellId)
#			cells.append(cellPos)
#		return cells
#	else:
#		return null
#
#func astar_exists(point):
#	return astar_is_in_bounds(point) and _astar.has_point(_astar_calc_point_index(point))
#
#func astar_is_in_bounds(point):
#	return not (point.x < 0 or point.y < 0 or point.x >= _astar_map_size.x or point.y >= _astar_map_size.y)
#
#func _astar_add_walkable_cells():
#	var points_array = []
#	for y in range(_astar_map_size.y):
#		for x in range(_astar_map_size.x):
#			var point = Vector2(x, y)
#
#			if _astar_is_cellvalue_obstacle(get_cellv(point)):
#				continue # obstacle
#
#			points_array.append(point)
#			var point_index = _astar_calc_point_index(point)
#			_astar.add_point(point_index, point)
#	return points_array
#
#func _astar_add_and_connect_walkable_cell(point):
#	if _astar_is_cellvalue_obstacle(get_cellv(point)):
#		return # obstacle. do not add or connect.
#
#	var point_index = _astar_calc_point_index(point)
#	_astar.add_point(point_index, point)
#	_astar_connect_walkable_cell(point)
#
#func _astar_connect_walkable_cells(points_array):
#	for point in points_array:
#		_astar_connect_walkable_cell(point)
#
#func _astar_connect_walkable_cell(point):
#	var point_index = _astar_calc_point_index(point)
#	var points_relative = PoolVector2Array([
#		point + Vector2.RIGHT,
#		point + Vector2.UP,
#		point + Vector2.LEFT,
#		point + Vector2.DOWN,
#	])
#	for point_relative in points_relative:
#		if not astar_is_in_bounds(point_relative):
#			continue
#		var point_relative_index = _astar_calc_point_index(point_relative)
#		if not _astar.has_point(point_relative_index):
#			continue
#
#		# third argument: bidirectionality
#		_astar.connect_points(point_index, point_relative_index, true)
#
#func _astar_calc_point_index(point):
#	return point.x + _astar_map_size.x * point.y
#
#func _astar_recalculate_path():
#	# drawing
#	var start_index = _astar_calc_point_index(_astar_start)
#	var end_index = _astar_calc_point_index(_astar_end)
#	_astar_point_path = _astar.get_point_path(start_index, end_index)
#
#func _astar_helper_get_next_point_in_path(path, current_point: Vector2):
#	for i in range(len(path)-1, -1, -1):
#		if current_point == path[i] and i + 1 < len(path):
#			return path[i + 1]
