tool
extends Node
class_name EdTiledLoadToMap

export(NodePath)var path_to_tilemap
export(String, DIR)var tmx_folder
export(String)var tmx_name
export(String, FILE)var tmx_direct_path
export(bool)var clear_on_load = false
export(bool)var click_to_load
export(Vector2)var offset = Vector2(0,0)

export(int)var load_map_width = 20
export(int)var load_map_height = 18

func _process(_delta):
	if click_to_load:
		click_to_load = false
		var loader = TiledLoader.new().setup(tmx_folder, load_map_width, load_map_height)
		var tilemap = get_node(path_to_tilemap)
		if loader and tilemap:
			var mapdata = null
			if tmx_direct_path:
				mapdata = loader.load_TiledMap_from_raw_tmx_path(tmx_direct_path)
			elif tmx_name:
				if tmx_folder: loader.tmx_path = tmx_folder
				else: pass#loader.tmx_path = 
				mapdata = loader.load_TiledMap_from_raw_tmx_path(loader.get_tmx_path_from_tmx_name(tmx_name))
			if mapdata:
				if clear_on_load: tilemap.clear()
				_place_TiledMap_tiles_on_tilemap(mapdata, tilemap, offset)
			else:
				print("EdTiledLoad FAILED: Could not find tmx (check params)")

func _place_TiledMap_tiles_on_tilemap(tiledMap: TiledMap, map: TileMap, offset: Vector2 = Vector2.ZERO):
	var x = 0
	var y = 0
	var ox = int(offset.x)
	var oy = int(offset.y)
	var w = tiledMap.get_width()
	for tile in tiledMap._tiles:
		tile -= 1
		map.set_cell(x+ox, y+oy, tile)
		x += 1
		if x >= w:
			x = 0
			y += 1
