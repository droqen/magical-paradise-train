tool
extends NavdiBitsySprite
class_name NavdiSheetSprite
export(Resource) var _editor_sheet = null
export(bool) var _reload_sheet = false
var _sheet = null
func _ready():
	self._sheet = null # clear, force reload
	set_sheet(_editor_sheet)
func _process(_delta):
	if Engine.editor_hint:
		if _reload_sheet or self._sheet != _editor_sheet:
			_reload_sheet = false
			self._sheet = null # clear, force reload
			set_sheet(_editor_sheet)
func set_sheet(sheet: NavdiSheet):
	if self._sheet != sheet:
		self._editor_sheet = sheet
		self._sheet = sheet
		if self._sheet == null:
			self.texture = null
			self.hframes = 1
			self.vframes = 1
		else:
			self.texture = sheet.sheet_texture
			self.hframes = sheet.sheet_hframes
			self.vframes = sheet.sheet_vframes
