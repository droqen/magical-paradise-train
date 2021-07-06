class_name NavdiTILEDLevelHandler

var _levelFolderPath: String
var _tilesetFolderPath: String
var _mapSize: Vector2
var _mapArea: int

var tilemap: NavdiMazeMaster

var levelDict = Dictionary()
var tilesetIdDict = Dictionary()
var tilesetTextures = []

var trackedTiles = LumpyDictionary.new()

var f_place_tile: FuncRef = funcref(self, "_place_tile")
var f_levelid_to_filename: FuncRef = funcref(self, "_levelid_to_filename")

enum { NO_DRAW, NON_SOLID, SOLID, SPAWN }

func _init(
	levelFolderPath:String = "res://illegal_level_folder/",
	mapSize: Vector2 = Vector2(20, 18),
	tilesetFolderPath = "inherit"):
	self._levelFolderPath = levelFolderPath
	self._mapSize = Vector2(int(mapSize.x), int(mapSize.y))
	self._mapArea = int(self._mapSize.x * self._mapSize.y)
	match tilesetFolderPath:
		"inherit":
			self._tilesetFolderPath = levelFolderPath
		null:
			self._tilesetFolderPath = ""
		_:
			self._tilesetFolderPath = tilesetFolderPath
	
func does_level_exist(levelid):
	if not levelDict.has(levelid):
		var tileArray = PoolIntArray()
		var levelPath = _levelFolderPath + f_levelid_to_filename.call_func(levelid)
		var flatLevel = _load_TILED_flatLevelData(levelPath)
		if not flatLevel:
			push_error("No leveldata for id %s at path %s" % [levelid, levelPath])
			return false
		if flatLevel.get_area() == _mapArea:
			levelDict[levelid] = flatLevel
#		for tileString in _load_TILED_tiles_string_path(levelPath, true).split(",", false):
#			tileArray.append(int(tileString))
#		if tileArray.size() == _mapArea:
#			levelDict[levelid] = FlatLevelData.new(
#				tileArray,
#				_mapSize.x,
#				_load_TILED_tileset_id(levelPath),
#				_load_TILED_objects(levelPath)
#			)
		else:
			levelDict[levelid] = null
			if tileArray.size() == 0:
				push_error("NavdiTILEDLevelHandler.gd / level %s does not exist" % [str(levelid)])
			else:
				push_error("NavdiTILEDLevelHandler.gd / level %s has bad area %d, expected area %d" % [str(levelid), tileArray.size(), _mapArea])
				if tileArray.size() == 1:
					push_warning("NavdiTILEDLevelHandler.gd / this error may occur due to bad Tile Layer Format. expected value is CSV")
	
	return levelDict[levelid] != null
	
func load_level(levelid):
	does_level_exist(levelid)
	var levelData: FlatLevelData = levelDict[levelid]
	if levelData:
		trackedTiles.dict.clear()
		var x = 0
		var y = 0
		if _tilesetFolderPath:
			_load_level_tileset(levelData)
		for tile in levelData._tiles:
			tile -= 1
			f_place_tile.call_func(x, y, tile)
			x += 1
			if x >= _mapSize.x:
				x = 0
				y += 1
		return levelData
	else:
		return false

func load_level_tileset(levelid):
	does_level_exist(levelid)
	var levelData: FlatLevelData = levelDict[levelid]
	if levelData:
		print(levelData._tileset_source_path)
		return levelData
	else:
		return false

func load_level_to_tilemap(levelid, _tilemap):
	self.tilemap = _tilemap
	return load_level(levelid)

# see f_ funcref variables at top

func _place_tile(x, y, tileid):
	tilemap.set_cell(x, y, tileid)

func _levelid_to_filename(levelid):
	return levelid
#	return str(levelid) + ".tmx"
#	return str(levelid[0]) + "_" + str(levelid[1]) + ".tmx"
	
#######################################################
################## private functions ##################
#######################################################
	
#func _load_TILED_tiles_string_coords(x, y, verbose = false):
#	var path = "res://single_screen_souls/levels/"+x+"_"+y+".tmx"
#	return _load_TILED_tiles_string_path(path, verbose)
	
func _load_TILED_flatLevelData(path):
	var parser = XMLParser.new()
	var tileArray = null
	var tilesetId = null
	var objectArray: Array = []
	var _ERR_PREFIX = "NavdiTILEDLevelHandler.gd / loading %s / " % [path]
	
	var currentObject: MazeObjectData = null
	if parser.open(path) != OK:
		push_error(_ERR_PREFIX + "no file at path %s" % path)
	else: while parser.read() == OK:
		if parser.get_node_type() == XMLParser.NODE_TEXT:
			pass # no name
		elif parser.get_node_type() == XMLParser.NODE_ELEMENT_END:
			pass # no name
		else: match parser.get_node_name():
			"data": # 'data' inside 'layer'
				if tileArray != null:
					push_error(_ERR_PREFIX + "multiple 'data' nodes found, ignoring all but first")
				elif parser.read() != OK:
					push_error(_ERR_PREFIX + "node 'data' found, next read failed")
				elif parser.get_node_type() != 3: # not text node
					push_error(_ERR_PREFIX + "node 'data' found, contains no text node")
				else:
					tileArray = _parse_TILED_tiles_data(parser.get_node_data())
			"tileset":
				if tilesetId != null:
					push_error(_ERR_PREFIX + "multiple 'tileset' nodes found, ignoring all but first")
				else: for i in range(parser.get_attribute_count()):
					if parser.get_attribute_name(i) == "source":
						var tilesetFileName = parser.get_attribute_value(i)
						tilesetId = _get_tileset_id(tilesetFileName)
			"object":
				var object_id = null
				var gid = null
				var position = Vector2.ZERO
				for i in range(parser.get_attribute_count()):
					match parser.get_attribute_name(i):
						"id": object_id = int(parser.get_attribute_value(i))
						"gid": gid = int(parser.get_attribute_value(i)) - 1 # subtract "firstgid"
						"x": position.x += float(parser.get_attribute_value(i))
						"y": position.y += float(parser.get_attribute_value(i))
						"width": position.x += float(parser.get_attribute_value(i)) * 0.5
						"height": position.y -= float(parser.get_attribute_value(i)) * 0.5
#				print("OBJECT!!! with gid = ", gid, " name ", parser.get_get_current_line)
				if gid == null:
					push_error(_ERR_PREFIX + "'object#%s' has no gid" % [str(object_id)])
				else:
					currentObject = MazeObjectData.new(gid, position)
					objectArray.append(currentObject)
			"property":
				if currentObject == null:
					push_error(_ERR_PREFIX + "'property' node found outside object")
				else:
					var propertyName = ""
					var propertyValue = ""
					for i in range(parser.get_attribute_count()):
						match parser.get_attribute_name(i):
							"name": propertyName = parser.get_attribute_value(i)
							"value": propertyValue = parser.get_attribute_value(i)
					if not propertyName:
						push_error(_ERR_PREFIX + "'property' node found with empty name attribute")
					else:
						currentObject._set_property(propertyName, propertyValue)
	
	if tileArray == null:
		push_error(_ERR_PREFIX + "no tileArray (no 'data' node)")
		return false
	if tilesetId == null:
		push_error(_ERR_PREFIX + "no tilesetId (no 'tileset' node)")
		return false
	
	return FlatLevelData.new(tileArray, _mapSize.x, tilesetId, objectArray)
	
func _parse_TILED_tiles_data(data) -> PoolIntArray:
	var tileArray = PoolIntArray()
	for tileString in data.split(",", false):
		tileArray.append(int(tileString))
	return tileArray
	
func _load_TILED_tiles_string_path(path, verbose = false):
	var parser = XMLParser.new()
	if parser.open(path) == OK:
		while parser.read() == OK:
			if parser.get_node_type() == XMLParser.NODE_TEXT:
				pass # no name
			elif parser.get_node_name() == "data":
				if parser.read() == OK:
					if parser.get_node_type() == 3: # text node
						return parser.get_node_data()
					elif verbose: push_error("NavdiTILEDLevelHandler.gd / _load_tiles / node 'data' found, contains no text node")
				elif verbose: pass
		if verbose: push_error("NavdiTILEDLevelHandler.gd / _load_tiles / node 'data' may not have been found")
	elif verbose: push_error("NavdiTILEDLevelHandler.gd / _load_tiles / no file at path %s" % path)
	
	return "" # failed
	
func _load_TILED_tileset_id(levelPath):
	if _tilesetFolderPath == null: return -1
	
	var parser = XMLParser.new()
	if parser.open(levelPath) == OK:
		while parser.read() == OK:
			if parser.get_node_type() == XMLParser.NODE_TEXT:
				pass # no name
			elif parser.get_node_name() == "tileset":
				for i in range(parser.get_attribute_count()):
					if parser.get_attribute_name(i) == "source":
						var tilesetFileName = parser.get_attribute_value(i)
						return _get_tileset_id(tilesetFileName)
	push_error("NavdiTILEDLevelHandler.gd / _load_tileset_id failed, no tileset source found")
	return null # failed

func _get_tileset_id(filename):
	if _tilesetFolderPath == null: return -1
	
	if tilesetIdDict.has(filename):
		return tilesetIdDict[filename]
	else:
		var filename_parts = filename.rsplit("/", false)
		var resourceFilename = filename_parts[len(filename_parts)-1].replace(".tsx", ".png").replace("tileset", "spritesheet")
#		print("TILEDLevelHandler.gd / _tilesetFolderPath = ", _tilesetFolderPath)
		var tilesetResource = load(_tilesetFolderPath + "/" + resourceFilename)
		if tilesetResource:
			var tilesetId = len(tilesetTextures)
			tilesetTextures.append(tilesetResource)
			tilesetIdDict[filename] = tilesetId
			return tilesetId
		else:
			push_error(
				"NavdiTILEDLevelHandler.gd / _get_tileset_id FAILED," +
				"no tileset resource at '%s' / '%s'"
				% [_tilesetFolderPath, resourceFilename])

func _load_level_tileset(level: FlatLevelData):
	if _tilesetFolderPath == null:
		push_error(
			"NavdiTILEDLevelHandler.gd / _load_level_tileset FAILED: " +
			"tilesetFolderPath is null (see _init)")
	
	var i = level._tileset_id
	if i >= len(tilesetTextures) or tilesetTextures[i] == null:
		push_error("bad tilesetId '%d'" % [i])
	if tilemap.tileset_image != tilesetTextures[i]:
		tilemap.load_tileset_image(tilesetTextures[i])
	tilemap.load_objects_from_leveldata(level)
#	return tilesetTextures[i]

const TRANSFORM_ANCHORS = [
	0,			2684354560,	3221225472,	1610612736,
	2147483648,	3758096384,	1073741824,	536870912,
]
