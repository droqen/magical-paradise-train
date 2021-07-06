tool
extends Node
class_name NavdiMazeLoaderTool

export(bool)var click_to_load
export(String, FILE)var level_path: String
export(Vector2)var level_size = Vector2(20, 18)

func _ready():
	if name == "NavdiMazeLoaderTool":
		name = "^MazeLoaderTool"

func _process(_delta):
	if click_to_load:
		click_to_load = false
		if level_path:
			load_my_path()
		else:
			push_warning("^MazeLoaderTool.gd / 'level_path' not set")

func load_my_path():
	load_path(level_path)

func load_path(_path: String):
	if get_parent() is TileMap:
		var level_parts = _path.rsplit("/", true, 1)
		if len(level_parts) > 1:
			var lh = NavdiTILEDLevelHandler.new(level_parts[0]+"/", level_size)
			lh.load_level_to_tilemap(level_parts[1], get_parent())
	else:
		push_warning("^MazeLoaderTool.gd / parent is not TileMap")
