extends KinematicBody2D
class_name NavdiMazeKineBody

var maze: NavdiMazeMaster
var _cell: Vector2
var lastMove: Vector2
var centerOffset: Vector2 = Vector2()

func setup(maze, cell):
	self.maze = maze
	_cell = cell
	lastMove = Vector2.ZERO
	self.position = maze.map_to_center(cell)
	if is_inside_tree():
		maze._register(_cell, self)
	return self
	
func on_set_cell(cell):
	pass # do nothing
	
func is_move_legal(_from, _to) -> bool:
	return true
	
func try_set_cell(target) -> bool:
	if is_move_legal(_cell, target):
		lastMove = target - _cell
		_set_cell(target)
		return true
	else:
		return false
		
func try_move(move) -> bool:
	return try_set_cell(_cell + move)
	
#	path = maze.astar_path(_cell, target)

func goto_next_cell_in_path(path):
	if path != null:
		var here3 = Vector3(_cell.x, _cell.y, 0)
		for i in range(len(path) - 1 - 1, -1, -1):
			if path[i] == here3:
				var move_success = try_set_cell(Vector2(path[i + 1].x, path[i + 1].y))
				return move_success
	return false
	
func get_center() -> Vector2:
	return maze.map_to_center(_cell) + centerOffset
func vector_to_center() -> Vector2:
	return get_center() - position
	
func get_bodies_within_reach(reach):
	var reach_squared = reach * reach
	var bodies = []
	var radius = ceil(reach / maze.cell_size.x)
	for dx in range(-radius, radius + 1):
		for dy in range(-radius, radius + 1):
			for body in maze.get_bodies(_cell + Vector2(dx, dy)):
				if body == self:
					continue
				if (body.position - self.position).length_squared() <= reach_squared:
					bodies.append(body)
	return bodies
	
func _enter_tree():
	if maze:
		maze._register(_cell, self)
func _exit_tree():
	if maze:
		maze._unregister(_cell, self)
func _set_cell(cell):
	if _cell != cell:
		maze._unregister(_cell, self)
		_cell = cell
		on_set_cell(_cell)
		maze._register(cell, self)
