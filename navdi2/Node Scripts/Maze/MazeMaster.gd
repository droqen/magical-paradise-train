tool
extends TileMap
class_name NavdiMazeMaster

export var click_to_apply: bool
export var solid_tiles_start_id: int = 1
export var spawn_tiles_start_id: int = 50
export var tileset_image: Texture
export var tileset_save_path: String = ""

var objects = []

func _ready():
	if Engine.editor_hint and tileset_image == null and cell_size == Vector2(64, 64):
		cell_size = Vector2(8, 8)
		tileset_image = load("res://navdi2/Resources/minirogue-all-thx-arachne.png")
		click_to_apply = true
	if not Engine.editor_hint:
		set_process(false) # no process

var bodies = LumpyDictionary.new()

func _register(cell, body):
	bodies.lump_add(cell, body)
	
func _unregister(cell, body):
	bodies.lump_remove(cell, body)
	
func get_bodies(cell):
	return bodies.lump_get_all(cell)
	
func map_to_center(cell):
	return map_to_world(cell) + cell_size / 2

func center(pos):
	return map_to_center(world_to_map(pos))

func replace_cells_by_id(ids, replacement_id = null):
	var replaced_cells: Array
	if ids is Array:
		replaced_cells = []
		for id in ids: replaced_cells += get_used_cells_by_id(id)
	else:
		replaced_cells = get_used_cells_by_id(ids)
	if replacement_id != null:
		for cell in replaced_cells: 
			set_cellv(cell, replacement_id)
	return replaced_cells
	
func get_vframes(): return int(floor(tileset_image.get_height() / cell_size.y))
func get_hframes(): return int(floor(tileset_image.get_width() / cell_size.x))
func get_totalframes(): return get_vframes() * get_hframes()
	
func _process(_delta):
	if Engine.editor_hint and click_to_apply:
		click_to_apply = false
		apply()

func apply():
	rebuild_tileset()

func load_objects_from_leveldata(leveldata):
	objects = leveldata.objects
	return objects

func load_tileset_image(image):
	self.tileset_image = image
	rebuild_tileset()

func rebuild_tileset():
	if tileset_save_path:
		if Engine.editor_hint:
			if ResourceLoader.exists(tileset_save_path):
				tile_set = ResourceLoader.load(tileset_save_path)
			else:
				tile_set = NavdiBoardTileSet.new()
				var err = ResourceSaver.save(tileset_save_path, tile_set)
				if err == OK:
					tile_set = ResourceLoader.load(tileset_save_path)
				else:
					print("Maze tilemap save failed: ",err)
	else:
		tile_set = NavdiBoardTileSet.new()
	
	var tile_ids = tile_set.get_tiles_ids()
	
	var vframes: int = int(floor(tileset_image.get_height() / cell_size.y))
	var hframes: int = int(floor(tileset_image.get_width() / cell_size.x))
	var total_frame_count = vframes * hframes
	var tile_hit_shape = RectangleShape2D.new()
	tile_hit_shape.extents = cell_size * 0.5
	var tile_hit_transform = Transform2D(0, tile_hit_shape.extents)
	for i in range(total_frame_count):
		if i in tile_ids: pass
		else: tile_set.create_tile(i)
		
		tile_set.tile_set_name(i, str(i).pad_zeros(3))
		tile_set.tile_set_texture(i, tileset_image)
# warning-ignore:integer_division
		tile_set.tile_set_region(i, Rect2(Vector2(i % hframes * cell_size.x, i / hframes * cell_size.y), cell_size))
		if _is_cellvalue_collision(i):
			tile_set.tile_set_shape(i, 0, tile_hit_shape)
			tile_set.tile_set_shape_transform(i, 0, tile_hit_transform)
		else:
			tile_set.tile_set_shape(i, 0, null)

func is_cell_solid(cell):
	return _is_cellvalue_collision(get_cellv(cell))

func _is_cellvalue_collision(cellvalue):
	return cellvalue >= solid_tiles_start_id and cellvalue < spawn_tiles_start_id

# virtual, abstract. PLEASE OVERRIDE ME.
func _astar_is_cellvalue_obstacle(cellvalue):
	return _is_cellvalue_collision(cellvalue)

var _astar: AStar2D
var _astar_points: Array
var _astar_point_count: int
var _astar_map_size: Vector2

var _astar_start: Vector2 = Vector2()
var _astar_end: Vector2 = Vector2()
var _astar_point_path = []

func astar_random_point():
	var point = _astar.get_point_position(_astar_points[randi() % _astar_point_count])
	return point
	
func astar_init(map_size: Vector2):
	_astar = AStar2D.new()
	_astar_map_size = map_size
	astar_generate_cells()
	
func astar_generate_cells():
	_astar.clear()
	var walkable_cells_list = _astar_add_walkable_cells()
	_astar_connect_walkable_cells(walkable_cells_list)
	_astar_points = _astar.get_points()
	_astar_point_count = len(_astar_points)
	
func astar_path(a, b):
	if astar_exists(a) and astar_exists(b):
		self._astar_start = a
		self._astar_end = b
		_astar_recalculate_path()
		return _astar_point_path
	else:
		return null
		
func astar_fill(point):
	if astar_is_in_bounds(point):
		var cellIds = [_astar.get_closest_point(point)]
		var onCellId = 0
		while onCellId < len(cellIds):
			for connected_point in _astar.get_point_connections(cellIds[onCellId]):
				if not cellIds.has(connected_point):
					cellIds.append(connected_point)
			onCellId += 1
		var cells = []
		for cellId in cellIds:
			var cellPos = _astar.get_point_position(cellId)
			cells.append(cellPos)
		return cells
	else:
		return null
		
func astar_exists(point):
	return astar_is_in_bounds(point) and _astar.has_point(_astar_calc_point_index(point))
		
func astar_is_in_bounds(point):
	return not (point.x < 0 or point.y < 0 or point.x >= _astar_map_size.x or point.y >= _astar_map_size.y)
	
func _astar_add_walkable_cells():
	var points_array = []
	for y in range(_astar_map_size.y):
		for x in range(_astar_map_size.x):
			var point = Vector2(x, y)
			
			if _astar_is_cellvalue_obstacle(get_cellv(point)):
				continue # obstacle
			
			points_array.append(point)
			var point_index = _astar_calc_point_index(point)
			_astar.add_point(point_index, point)
	return points_array
	
func _astar_add_and_connect_walkable_cell(point):
	if _astar_is_cellvalue_obstacle(get_cellv(point)):
		return # obstacle. do not add or connect.
	
	var point_index = _astar_calc_point_index(point)
	_astar.add_point(point_index, point)
	_astar_connect_walkable_cell(point)
	
func _astar_connect_walkable_cells(points_array):
	for point in points_array:
		_astar_connect_walkable_cell(point)
			
func _astar_connect_walkable_cell(point):
	var point_index = _astar_calc_point_index(point)
	var points_relative = PoolVector2Array([
		point + Vector2.RIGHT,
		point + Vector2.UP,
		point + Vector2.LEFT,
		point + Vector2.DOWN,
	])
	for point_relative in points_relative:
		if not astar_is_in_bounds(point_relative):
			continue
		var point_relative_index = _astar_calc_point_index(point_relative)
		if not _astar.has_point(point_relative_index):
			continue
		
		# third argument: bidirectionality
		_astar.connect_points(point_index, point_relative_index, true)

func _astar_calc_point_index(point):
	return point.x + _astar_map_size.x * point.y
	
func _astar_recalculate_path():
	# drawing
	var start_index = _astar_calc_point_index(_astar_start)
	var end_index = _astar_calc_point_index(_astar_end)
	_astar_point_path = _astar.get_point_path(start_index, end_index)

func _astar_helper_get_next_point_in_path(path, current_point: Vector2):
	for i in range(len(path)-1, -1, -1):
		if current_point == path[i] and i + 1 < len(path):
			return path[i + 1]
