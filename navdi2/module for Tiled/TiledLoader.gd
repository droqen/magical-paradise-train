class_name TiledLoader

# TiledLoader is really just an aspect of TiledManager.

var tmx_path
#var feditors: Node
var map_width: int
var map_height: int

func setup_tiledmanager(manager):
	tmx_path = manager.load_map_tmx_path+"/"
#	feditors = manager.get_node("FlagEditors")
	map_width = manager.load_map_width
	map_height = manager.load_map_height
	return self
func setup(_tmx_path, _map_width, _map_height):
	tmx_path = _tmx_path
	map_width = _map_width
	map_height = _map_height
	return self

func get_tmx_path_from_tmx_name(tmx_name):
	return tmx_path + tmx_name + ".tmx"

func load_TiledMap_from_raw_tmx_path(path):
	var parser = XMLParser.new()
	var tileArray = null
	var tsx_name = null
	var objectArray: Array = []
	var _ERR_PREFIX = "TiledLoader.gd / loading %s / " % [path]
	
	var currentObject: MazeObjectData = null
	if parser.open(path) != OK:
		push_error(_ERR_PREFIX + "no file at path %s" % path)
	else: while parser.read() == OK:
		if parser.get_node_type() == XMLParser.NODE_TEXT:
			pass # no name
		elif parser.get_node_type() == XMLParser.NODE_ELEMENT_END:
			pass # no name
		else: match parser.get_node_name():
			"map": # map properties
				for i in range(parser.get_attribute_count()):
					if parser.get_attribute_name(i) == "width":
						map_width = int(parser.get_attribute_value(i))
			"data": # 'data' inside 'layer'
				if tileArray != null:
					push_error(_ERR_PREFIX + "multiple 'data' nodes found, ignoring all but first")
				elif parser.read() != OK:
					push_error(_ERR_PREFIX + "node 'data' found, next read failed")
				elif parser.get_node_type() != 3: # not text node
					push_error(_ERR_PREFIX + "node 'data' found, contains no text node")
				else:
					tileArray = _get_tileArray_from_tmx_raw_tiles_data(parser.get_node_data())
			"tileset":
				if tsx_name != null:
					push_error(_ERR_PREFIX + "multiple 'tileset' nodes found, ignoring all but first")
				else: for i in range(parser.get_attribute_count()):
					if parser.get_attribute_name(i) == "source":
						var tilesetFileName = parser.get_attribute_value(i)
						var filename_parts = tilesetFileName.rsplit("/", false)
						tsx_name = filename_parts[len(filename_parts)-1].rsplit('.', 1)[0]
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
	
	return TiledMap.new(tileArray, map_width, tsx_name, objectArray)

func _get_tileArray_from_tmx_raw_tiles_data(data) -> PoolIntArray:
	var tileArray = PoolIntArray()
	for tileString in data.split(",", false):
		tileArray.append(int(tileString))
	return tileArray
