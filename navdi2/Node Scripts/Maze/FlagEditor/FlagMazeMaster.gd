tool
extends NavdiMazeMaster
class_name NavdiFlagMazeMaster

var _flag_editor = null

export(NodePath)var flag_editor_path = "."
export(bool) var click_to_apply_flag_editor = false

func get_cellvalue_flag(cellvalue):
	return _flag_editor.get_cellvalue_flag(cellvalue)
		
#func get_used_cells_by_flag(flagvalue): # figure this one out later
#	var used_cells = []
#	for cellid in _s2f.keys():
#		if _s2f[cellid] == flagvalue:
#			used_cells += get_used_cells_by_id(cellid)
#	return used_cells

func _process(_delta):
	if Engine.editor_hint and click_to_apply_flag_editor:
		click_to_apply_flag_editor = false
		flagmaze_setup(get_node(flag_editor_path))

func flagmaze_setup(flag_editor):
	self._flag_editor = flag_editor
	cell_size = flag_editor.get_edited_maze().cell_size
	load_tileset_image(flag_editor.master_tileset_image)
	rebuild_tileset()
	return self
	
func flagmaze_clear():
	self.tileset_image = null

const SolidFlagIds = [1, 10, 13] # TEMPORARY
#	SolidWall = 1,
#	OneWayWall = 13,
#	SpawnObject = 2,
#	ILLEGALTile = 10,
#	DefaultFloor = 20,

# override
func _is_cellvalue_collision(cellvalue):
	return get_cellvalue_flag(cellvalue) in SolidFlagIds

func _astar_is_cellvalue_obstacle(cellvalue):
	return _is_cellvalue_collision(cellvalue)
