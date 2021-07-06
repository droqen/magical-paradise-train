tool
extends NavdiMazeMaster
class_name NavdiFlagEditor

export var _s2f: Dictionary
export var _defaultFloorTile: int = 0

const FlagEditorSpritesheet = preload("res://navdi2/Node Scripts/Maze/FlagEditor/flags_sprites.png")

#enum Flag {
#	Floor = 0,
#	SolidWall = 1,
#	OneWayWall = 13,
#	SpawnObject = 2,
#	ILLEGALTile = 10,
#	DefaultFloor = 20,
#}
const SolidFlagIds = [
	NavdiBoardTileMap.Flag.SolidWall,
	NavdiBoardTileMap.Flag.ILLEGALTile,
	NavdiBoardTileMap.Flag.OneWayWall]

func _ready():
	self.cell_y_sort = true
	_s2f.clear()
	if has_node("Tiles"):
		rebuild_tileset()

export(Texture)var master_tileset_image = null
export(Vector2)var master_cell_size = Vector2(8,8)
export(bool)var click_to_cleanup_strays = false
export(bool)var click_both_to_clear_all_flags
export(bool)var click_both_to_clear_all_flags_2

func _process(_delta):
	if Engine.editor_hint:
		if click_to_cleanup_strays:
			cleanup_strays()
			click_to_cleanup_strays = false
		if click_both_to_clear_all_flags and click_both_to_clear_all_flags_2:
			clear()
			click_both_to_clear_all_flags = false
			click_both_to_clear_all_flags_2 = false

func cleanup_strays():
	var zone = TileZone.new(Vector2($Tiles.get_hframes(), $Tiles.get_vframes()))
	for cell in get_used_cells():
		if not zone.has_point(cell):
			set_cellv(cell, -1)

func apply():
	if not has_node("Tiles"):
		#own_node Tiles
		var maze = NavdiFlagBackingMazeMaster.new()
		maze.name = "Tiles"
		self.add_child(maze)
		maze.set_owner(self.owner)
		maze.collision_layer = 0
		maze.collision_mask = 0
		maze.flagmaze_setup(self)
		maze.flag_editor_path = maze.get_path_to(self)
		print("Tiles added ",get_children())
	
	if $Tiles.tileset_image != master_tileset_image:
		self.tileset_image = FlagEditorSpritesheet
		rebuild_tileset()
		$Tiles.rebuild_tileset()
		clear()
	else:
		rebuild_tileset()

func load_tileset_image(image):
	print("load tileset image")
	self.master_tileset_image = image
	apply()
	
func get_edited_maze() -> NavdiFlagMazeMaster:
	var maze: NavdiFlagMazeMaster = get_node("Tiles")
	return maze

func rebuild_tileset():
	if not has_node("Tiles"):
		push_error("NavdiFlagEditor %s needs a child NavdiMazeMaster named 'Tiles'" % name)
	
	self.tileset_image = FlagEditorSpritesheet
	self.cell_size = Vector2(16, 16)
	
	.rebuild_tileset()
	
	tile_set.cell_size = master_cell_size
	
	$Tiles.clear()
	$Tiles.show_behind_parent = true
	$Tiles.tileset_image = master_tileset_image
	$Tiles.tile_set.cell_size = master_cell_size
	$Tiles.cell_size = master_cell_size
	$Tiles.cell_custom_transform.x.x = master_cell_size.x
	$Tiles.cell_custom_transform.y.y = master_cell_size.y
	$Tiles.rebuild_tileset()
	var i = 0
	for y in range(0, $Tiles.get_vframes()):
		for x in range(0, $Tiles.get_hframes()):
			$Tiles.set_cell(x, y, i)
			i += 1
	self.scale = master_cell_size / self.cell_size
	$Tiles.scale = Vector2.ONE / self.scale # invert scale
	
	print("rebuild...")
	
	$Tiles.tile_set.values_to_flags = []
	for y in range(0, $Tiles.get_vframes()):
		for x in range(0, $Tiles.get_hframes()):
			var flag = self.get_cell(x, y)
			$Tiles.tile_set.values_to_flags.append(flag)
	
func get_all_object_sids():
	print("TODO: optimize/rename FlagEditor.get_all_object_sids")
	var object_sids = []
	var sid = 0
	
	for y in range(0, $Tiles.get_vframes()):
		for x in range(0, $Tiles.get_hframes()):
			var flag = self.get_cell(x, y)
			if flag == NavdiBoardTileMap.Flag.SpawnObject:
				object_sids.append(sid)
			sid += 1
	return object_sids
func get_default_floor_sid():
	print("TODO: fix FlagEditor.get_default_floor_sid")
	return _defaultFloorTile

func _is_cellvalue_collision(cellvalue):
	return get_cellvalue_flag(cellvalue) in SolidFlagIds

func get_cellvalue_flag(cellvalue):
	if cellvalue < 0: return -1
	else: return self.get_cell(
		int(cellvalue % $Tiles.get_hframes()),
		int(cellvalue / $Tiles.get_hframes())
	)
