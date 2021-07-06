class_name TileZone

var position
var size

func _init(size_or_sourceTileZone, _position: Vector2 = Vector2.ZERO):
	if size_or_sourceTileZone is Vector2:
		var _size = size_or_sourceTileZone
		self.position = _position
		self.size = _size
	else:
		var _sourceTileZone = size_or_sourceTileZone
		self.position = _sourceTileZone.position
		self.size = _sourceTileZone.size
		
func expanded(amount):
	self.size += amount * 2 * Vector2.ONE
	self.position -= amount * Vector2.ONE
	return self

func do_each_point(funcref_point_action):
	for x in range(int(ceil(position.x)), int(position.x + size.x)):
		for y in range(int(ceil(position.y)), int(position.y + size.y)):
			funcref_point_action.call_func(Vector2(x, y))
			
func get_all_cells():
	var cells = []
	for x in range(int(ceil(position.x)), int(position.x + size.x)):
		for y in range(int(ceil(position.y)), int(position.y + size.y)):
			cells.append(Vector2(x, y))
	return cells

func has_point(point):
	return (point.x >= self.position.x
		and point.y >= self.position.y
		and point.x < self.position.x + self.size.x
		and point.y < self.position.y + self.size.y)
