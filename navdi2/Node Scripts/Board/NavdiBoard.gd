tool
extends Node2D
class_name NavdiBoard

signal state_changed

export(Vector2) var board_view_size = Vector2(160, 144)
export(NodePath) var tiled_manager_path = "TiledManager"
export(bool)var force_setup = false
export(NodePath) var source_tilemap_path = ""
export(String) var source_tilemap_name = ""
export(bool)var apply_tilemap = false
export(bool)var show_outline = false
#export(NodePath) var source_tmx = "" # unimplemented
#export(bool)var load_tmx = false # unimplemented

var tilemap_maze: NavdiMazeMaster = null

var state: NavdiBoardState = null

func setup():
#	if has_node("State"):
#		push_error("NavdiBoard.setup() on node '%s' failed. REASON: must not have 'State' child" % [get_path()])
#		return false
	var boardState
	for child in get_children():
		if child is NavdiBoardState:
			boardState = child
	if boardState == null:
		boardState = NavdiBoardState.new()
		boardState.name = "State"
		self.add_child(boardState)
		boardState.set_owner(owner if owner else self)
	if tiled_manager_path == "TiledManager" and not has_node("TiledManager"):
		spawn_tiledmanager()
	boardState.position = Vector2.ZERO#board_view_size * 0.5
	self.position = board_view_size * 0.5
	hide()
	show()
	return self

func spawn_tiledmanager():
	var tiled_manager = TiledManager.new()
	tiled_manager.name = "TiledManager"
	self.add_child(tiled_manager)
	tiled_manager.set_owner(owner if owner else self)
	tiled_manager.force_setup = true
	tiled_manager.tileset_save_folder = self.filename.rsplit("/",false,1)[0]

func refresh_tilemap():
	var source_tilemap_node: NavdiMazeMaster
	
	if source_tilemap_path and has_node(source_tilemap_path):
		source_tilemap_node = get_node(source_tilemap_path)
	elif source_tilemap_name and has_node(str(tiled_manager_path)+"/FlagEditors/"+source_tilemap_name):
		source_tilemap_node = get_node(str(tiled_manager_path)+"/FlagEditors/"+source_tilemap_name)
	
	if not source_tilemap_node:
		push_error("NavdiBoard.refresh_tilemap() on node '%s' failed. REASON: must have a source tilemap." % [get_path()])
		return
	
	if not has_node("State/TileMap"):
		_own_node(NavdiBoardTileMap.new(), "TileMap", $State)
	if source_tilemap_node.has_node("Tiles"):
		source_tilemap_node = source_tilemap_node.get_node("Tiles")
	set_tilemap_maze(source_tilemap_node)
	update()

func set_tilemap_maze(source_tilemap_node):
	var tile_set : TileSet = source_tilemap_node.tile_set
	
	self.tilemap_maze = source_tilemap_node
	$State/TileMap.tile_set = source_tilemap_node.tile_set
	$State/TileMap.cell_size = source_tilemap_node.cell_size
	$State/TileMap.cell_y_sort = source_tilemap_node.cell_y_sort
	$State/TileMap.cell_tile_origin = source_tilemap_node.cell_tile_origin
	$State/TileMap.cell_quadrant_size = source_tilemap_node.cell_quadrant_size
	$State/TileMap.cell_custom_transform = source_tilemap_node.cell_custom_transform
	
	if not $State/TileMap.get_used_cells():
		# get default floor tile!
		var default_floor_tile = 0
		var view_cell_size_2 = board_view_size/tilemap_maze.cell_size
		view_cell_size_2.x = round(view_cell_size_2.x*0.5)*2
		view_cell_size_2.y = round(view_cell_size_2.y*0.5)*2
		if tilemap_maze.get_parent() is NavdiFlagEditor:
			var flag_editor: NavdiFlagEditor = tilemap_maze.get_parent()
			default_floor_tile = $State/TileMap.get_default_floor_tile()
		for cell in TileZone.new(view_cell_size_2, view_cell_size_2 * -0.5).get_all_cells():
			$State/TileMap.set_cellv(cell, default_floor_tile)

func _draw():
	if Engine.editor_hint and show_outline:
		draw_rect(Rect2(
			-board_view_size * 0.5,
			board_view_size - Vector2.ONE
		),Color.magenta, false, 1)

func _get_configuration_warning():
	if Engine.editor_hint:
		if not has_node("State"): return "This NavdiBoard is improperly set up. It needs a NavdiBoardState node called 'State'. (If you check 'Force Setup' it will set itself up."
	return ""

func _process(_delta):
	if Engine.editor_hint:
		if force_setup:
			force_setup = false
			setup()
		if apply_tilemap:
			apply_tilemap = false
			refresh_tilemap()

func _own_node(node, nodename, parent=self):
	node.name = nodename
	parent.add_child(node)
	node.set_owner(parent.owner)
	return node

func get_state():
	if not self.state:
		for s in get_children(): if s is NavdiBoardState:
			self.state = s
			return self.state
	return self.state

func change_state(new_state):
	for s in get_children(): if s is NavdiBoardState: remove_child(s)
	self.state = new_state
	
#	print("change_state? ",new_state.filename)
#	if "the_end" in new_state.filename:
#		print("the_end")
#		LocalSave.set_endgame_true()
	
	if self.state: add_child(self.state)
	emit_signal("state_changed")
#	print("change_state", self.state)
	
	return self.state
