class_name MazeObjectData
var gid
var position
var properties # ?
func _init(_gid, _pos):
	self.gid = _gid
	self.position = _pos
func _set_property(name, value):
	if not self.properties:
		self.properties = Dictionary()
	self.properties[name] = value
