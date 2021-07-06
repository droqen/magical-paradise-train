tool
extends Node
export(bool)var allow_existing_folder
export(bool)var create_new_tiled_project
export(String)var tiled_project_folder
export(String)var tiled_project_name
export(bool)var create_new_tileset_file
export(Texture)var tileset_spritesheet

const TEMPLATE_PATH = "res://navdi2/module for Tiled/template/"
const TEMPLATE_PREFIX = "template-"

func _get_new_project_path():
	if tiled_project_folder:
		return "res://%s/%s/" % [tiled_project_folder, tiled_project_name]
	else:
		return "res://%s/" % [tiled_project_name]
	
func _get_new_prefix():
	return tiled_project_name + "-"

func copy_replace(filepath1, filepath2, replaces, withs, file: File = null):
	if not file: file = File.new()
	file.open(filepath1, File.READ)
	var fileString = file.get_as_text()
	for i in range(min(len(replaces), len(withs))):
		fileString = fileString.replace(replaces[i], withs[i])
	file.close()
	file.open(filepath2, File.WRITE)
	file.store_string(fileString)
	file.close()

func _process(_delta):
	if create_new_tiled_project:
		create_new_tiled_project = false
		
		var newProjectPath = _get_new_project_path()
		var newPrefix = _get_new_prefix()
		
		if len(tiled_project_name) <3:
			push_error("SETUP NEW TILED PROJECT FAILED: tiled_project_name '%s' is too short" % tiled_project_name)
		else:
			var dir = Directory.new()
			var folder_exists = dir.dir_exists(newProjectPath)
			if folder_exists and not self.allow_existing_folder:
				push_error("SETUP NEW TILED PROJECT FAILED: folder '%s' already exists" % newProjectPath)
			else:
				self.allow_existing_folder = false
				if not folder_exists:
					dir.make_dir(newProjectPath)
					print("SETUP NEW TILED PROJECT '%s'" % [tiled_project_name.to_upper()])
				
				var file = File.new()
				
				for baseFileName in [
					"project.tiled-project",
					"project.tiled-session",
#					"spritesheet.xcf",
					"spritesheet.png",
					"tileset.tsx",
					"test-map.tmx",
				]:
					match baseFileName:
						"spritesheet.png":
							# doing get_as_text on a .png file causes errors. so don't do it.
							dir.copy(
								TEMPLATE_PATH + TEMPLATE_PREFIX + baseFileName,
								newProjectPath + newPrefix + baseFileName
							)
						_:
							copy_replace(
								TEMPLATE_PATH + TEMPLATE_PREFIX + baseFileName,
								newProjectPath + newPrefix + baseFileName,
								["template"],
								[tiled_project_name],
								file
							)
					print("created: %s" % [newProjectPath + newPrefix + baseFileName])
				
#				print("replaced all instances of 'template' with '%s'" % tiled_project_name)
#				var file = File.new()
#				file.open(newProjectPath + newPrefix + "tileset.tsx", File.READ)
	
	if create_new_tileset_file:
		create_new_tileset_file = false
		
		var newProjectPath = _get_new_project_path()
		var newPrefix = _get_new_prefix()
		
		if tileset_spritesheet:
			var path = tileset_spritesheet.resource_path
			if not "/"+tiled_project_name+"/" in path:
				push_error("SETUP NEW TILESET FILE FAILED: tileset '%s' is not in project folder '%s'" % [path, newProjectPath])
			var spritesheet_filename = path.rsplit("/", false, 1)[1]
			var tileset_filename = spritesheet_filename.replace(".png", ".tsx").replace("spritesheet", "tileset")
			copy_replace(
				TEMPLATE_PATH + TEMPLATE_PREFIX + "tileset.tsx",
				newProjectPath + tileset_filename,
				[TEMPLATE_PREFIX + "spritesheet.png"],
				[spritesheet_filename]
			)
			tileset_spritesheet = null
		else:
			push_error("SETUP NEW TILESET FILE FAILED: tileset_spritesheet is null")
