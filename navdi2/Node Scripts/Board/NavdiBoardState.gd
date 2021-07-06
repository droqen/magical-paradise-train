# NavdiBoardStates are for being saved. everything from here on down needs to be serializable.
extends Node2D
class_name NavdiBoardState

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func pack():
	var pscn = PackedScene.new()
	print("RecurseStart")
	for child in get_children():
		own_node_recursive_except_prefabs(child, self)
	pscn.pack(self)
	return pscn

func add_child( node:Node, legible_unique_name:bool=true ) -> void:
	.add_child(node, legible_unique_name )
	own_node_recursive_except_prefabs(node, self)

func own_node_recursive_except_prefabs(node, new_owner, prefab_owners = []):
	if node.owner in prefab_owners: return # don't own prefab-children
	node.set_owner(new_owner)
#	if node.filename.empty(): # the previous prefab checker.
	for child in node.get_children():
		own_node_recursive_except_prefabs(child, new_owner, prefab_owners + [node])

func map_to_center(cell): # only use if i have a TileMap, please!
	return $TileMap.map_to_world(cell) + $TileMap.cell_size * 0.5
