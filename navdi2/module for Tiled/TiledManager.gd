tool
extends Node2D
class_name TiledManager

signal applied_map_to_maze(map, maze)

export(bool)var force_setup = false
export(Array, Texture)var tileset_textures = [preload("res://navdi2/Resources/minirogue-all-thx-arachne.png")]
export(bool)var check_tilesets = false
export(bool)var tilesets_nofilter = true
export(String, DIR) var tileset_save_folder = ""

export(int)var load_map_width = 20
export(int)var load_map_height = 18
export(String, DIR) var load_map_tmx_path = "res://"
var _loader: TiledLoader = null
var _pyxelLoader: PyxelLoader = null
export(bool) var load_TiledMap_from_pyxel = false

func setup():
	if not load_map_tmx_path or load_map_tmx_path.ends_with("//"):
		push_warning("TiledManager.load_map_tmx_path is not set (%s). That's fine if you're not gonna use it though." % get_path())
	
	if has_node("FlagEditors"):
		push_error("TiledManager.setup() on node '%s' failed. REASON: must not have 'FlagEditors' child" % [get_path()])
		return false
	for child in get_children():
		child.name = "(deleted)"
		child.queue_free()
	_own_node(Node2D.new(), "FlagEditors")
	return self

func load_TiledMap(key: String) -> TiledMap: # you can override this.
	if load_TiledMap_from_pyxel:
		return load_TiledMap_from_Pyxel(key, $FlagEditors.get_child(0).name)
	else:
		return load_TiledMap_from_tmx(key)

func load_TiledMap_from_tmx(tmx_name: String) -> TiledMap:
	var tmx_path = _get_loader().get_tmx_path_from_tmx_name(tmx_name)
	var tiledMap: TiledMap = _get_loader().load_TiledMap_from_raw_tmx_path(tmx_path)
	_convert_tiles_to_objects_in_TiledMap(tiledMap)
	return tiledMap
	
func load_TiledMap_from_Pyxel(txt_name: String, tsx_name: String) -> TiledMap:
	var txt_path = _get_pyxelLoader().get_pyxel_path_from_txt_name(txt_name)
	var tiledMap: TiledMap = _get_pyxelLoader().load_TiledMap_from_raw_pyxel_path(txt_path, tsx_name)
	_convert_tiles_to_objects_in_TiledMap(tiledMap)
	return tiledMap

func apply_TiledMap_to_maze(tiledMap: TiledMap, maze: NavdiFlagMazeMaster):
	maze.flagmaze_setup(_get_flagEditorNode_from_TiledMap(tiledMap))
#	maze.objectify_TiledMap(tiledMap)
	_place_TiledMap_tiles_on_maze(tiledMap, maze)
	if tiledMap.objects and not get_signal_connection_list("applied_map_to_maze"):
		push_error("TiledManager signal 'applied_map_to_maze' is not connected (%s)" % get_path())
	else:
		emit_signal("applied_map_to_maze", tiledMap, maze)


func _ready():
	if not Engine.editor_hint:
		hide()
		set_process(false)
		# warning-ignore:return_value_discarded
#		_get_loader() # why?

func _get_loader() -> TiledLoader:
	if _loader == null:
		_loader = TiledLoader.new().setup_tiledmanager(self)
	return _loader

func _get_pyxelLoader() -> PyxelLoader:
	if _pyxelLoader == null:
		_pyxelLoader = PyxelLoader.new(self)
	return _pyxelLoader

func _own_node(node, nodename, parent=self):
	node.name = nodename
	parent.add_child(node)
	node.set_owner(parent.owner)
	return node

func _process(_delta):
	if Engine.editor_hint:
		if force_setup:
			force_setup = false
			setup()
		if check_tilesets:
			var valid_flagEditorNodes = []
			check_tilesets = false
			for texture in tileset_textures:
				var flagEditorNode = _get_flagEditorNode_from_texture(texture)
				valid_flagEditorNodes.append(flagEditorNode)
				if tilesets_nofilter:
					if texture.flags:
						texture.flags = 0
						ResourceSaver.save(texture.resource_path, texture)
			for child in $FlagEditors.get_children():
				if not child in valid_flagEditorNodes and not child.name.begins_with("(?)"):
					child.name = "(?) " + child.name
				child.collision_layer = 0
				child.collision_mask = 0
				
				if tileset_save_folder:
					child.get_node("Tiles").tileset_save_path = "%s/%s_tileset.res" % [tileset_save_folder, child.name]
				
				child.apply()
#				child.get_node("Tiles").rebuild_tileset()

func _get_flagEditorNode_from_texture(texture:Texture) -> NavdiFlagEditor:
	var tsx_name = texture.resource_path.rsplit("/", false, 1)[1].split(".", false, 1)[0]
	var flagEditorNode: NavdiFlagEditor
	if $FlagEditors.has_node(tsx_name):
		flagEditorNode = $FlagEditors.get_node(tsx_name)
	else:
		flagEditorNode = _own_node(NavdiFlagEditor.new(), tsx_name, $FlagEditors)
		flagEditorNode.load_tileset_image(texture)
	return flagEditorNode
func _get_flagEditorNode_from_TiledMap(tiledMap: TiledMap) -> NavdiFlagEditor:
	var flagEditorNode: NavdiFlagEditor = get_node("FlagEditors/%s"%tiledMap.tsx_name)
	return flagEditorNode

func _place_TiledMap_tiles_on_maze(tiledMap: TiledMap, maze: NavdiMazeMaster):
	var x = 0
	var y = 0
	for tile in tiledMap._tiles:
		tile -= 1
		maze.set_cell(x, y, tile)
		x += 1
		if x >= load_map_width:
			x = 0
			y += 1

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

func _convert_tiles_to_objects_in_TiledMap(tiledMap: TiledMap) -> void:
	var flagEditorNode: NavdiFlagEditor = _get_flagEditorNode_from_TiledMap(tiledMap)
	var flagsToSids = flagEditorNode.get_flags_to_sids()
	var objectSids = flagEditorNode.get_all_object_sids()
	var defaultFloorSid = flagEditorNode.get_default_floor_sid()
	
	var x = 0
	var y = 0
	for i in range(tiledMap.get_area()):
		if tiledMap._tiles[i] - 1 < 0:
			tiledMap._tiles[i] = defaultFloorSid + 1
		elif tiledMap._tiles[i] - 1 in objectSids:
			tiledMap.objects.append(MazeObjectData.new(
				tiledMap._tiles[i] - 1, flagEditorNode.get_edited_maze().map_to_center(Vector2(x, y))))
			tiledMap._tiles[i] = defaultFloorSid + 1
		x += 1
		if x >= load_map_width:
			x = 0
			y+= 1
