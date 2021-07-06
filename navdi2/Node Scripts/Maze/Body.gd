extends RigidBody2D
class_name NavdiMazeBody

var maze: NavdiMazeMaster
var _cell: Vector2
var lastMove: Vector2
var centerOffset: Vector2 = Vector2()

func setup(_maze, __cell):
	self.maze = _maze
	_cell = __cell
	lastMove = Vector2.ZERO
	self.position = maze.map_to_center(_cell)
	if is_inside_tree():
		maze._register(_cell, self)
	return self

func on_set_cell(__cell):
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
		for i in range(len(path) - 1 - 1, -1, -1):
			if path[i] == _cell:
				var move_success = try_set_cell(path[i + 1])
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
	if maze and is_instance_valid(maze):
		maze._register(_cell, self)
func _exit_tree():
	if maze and is_instance_valid(maze): # maze is free, don't unregister me
		maze._unregister(_cell, self)
func _set_cell(cell):
	if _cell != cell:
		maze._unregister(_cell, self)
		_cell = cell
		on_set_cell(_cell)
		maze._register(cell, self)
