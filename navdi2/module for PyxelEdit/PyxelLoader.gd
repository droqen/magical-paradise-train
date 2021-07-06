class_name PyxelLoader

# TiledLoader is really just an aspect of TiledManager.

var txt_path
var feditors: Node
var map_width: int
var map_height: int
var tilewidth: int = 8
var tileheight: int = 8

func _init(manager): # TiledManager
	txt_path = manager.load_map_tmx_path+"/"
	feditors = manager.get_node("FlagEditors")
	map_width = manager.load_map_width
	map_height = manager.load_map_height

func get_pyxel_path_from_txt_name(txt_name):
	return txt_path + txt_name + ".txt"

func load_TiledMap_from_raw_pyxel_path(path, texture_name):
	var in_tile_layer = false
	var in_object_layer = false
	var reader = File.new()
	var err = reader.open(path, File.READ)
	if err:
		push_error("PyxelLoader: err %s on path %s" % [str(err), path])
		return null
#	var tileswide = 20
#	var tileshigh = 18
#	var tilewidth = 8
#	var tileheight = 8
	var tileArray = null
	var objectArray = []
	var objectLine = 0
	var consecutive_blank_lines = 0
	while consecutive_blank_lines < 2:
		var line = reader.get_line()
		if line: consecutive_blank_lines = 0
		else: consecutive_blank_lines += 1
		
		if in_tile_layer or in_object_layer:
			consecutive_blank_lines = 0
			if line:
				if in_tile_layer:
					for c in line.split(",", false, map_width):
						tileArray.append(int(c) + 1)
				else:
					var x = 0
					for c in line.split(",", false, map_width):
						if c != "-1":
							# warning-ignore:integer_division
							# warning-ignore:integer_division
							objectArray.append(MazeObjectData.new(int(c), Vector2(x*tilewidth+tilewidth/2, objectLine*tileheight+tileheight/2)))
						x += 1
					objectLine += 1
			else:
				consecutive_blank_lines += 1
				in_tile_layer = false
				in_object_layer = false
		else:
			var args = line.split(" ")
			match args[0]:
				"tileswide": if int(args[1]) != map_width: push_error("PyxelLoader: map_width(%d) != tileswide(%d) @ path %s" % [map_width, int(args[1]), path])
				"tileshigh": if int(args[1]) != map_height: push_error("PyxelLoader: map_height(%d) != tileshigh(%d) @ path %s" % [map_height, int(args[1]), path])
#				"tileswide": tileswide = int(args[1])
#				"tileshigh": tileshigh = int(args[1])
				"tilewidth": tilewidth = int(args[1])
				"tileheight": tileheight = int(args[1])
				"layer":
					if args[1] == "0":
						in_tile_layer = true
						tileArray = []
					else:
						in_object_layer = true
	
	if tileArray == null:
		push_error("PyxelLoader: no tileArray (no 'layer 0)")
		return false
	
	return TiledMap.new(tileArray, map_width, texture_name, objectArray)
