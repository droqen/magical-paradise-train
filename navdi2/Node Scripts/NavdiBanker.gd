extends Node
class_name NavdiBanker

signal spawned(node)

func _ready():
	for child in get_children(): child.set_process(false)
	_bank_get()

export var starting_group_container:NodePath = ""

var bank:Node setget _bank_set, _bank_get

var group_container:Node setget _container_set, _container_get

func _bank_set(newBank):
	for child in get_children():
		self.remove_child(child)
		newBank.add_child(child)
	if bank != null:
		print("NavdiBanker \""+self.name+"\" is migrating children to a new bank")
		for child in bank:
			bank.remove_child(child)
			newBank.add_child(child)
	bank = newBank
	
func _bank_get():
	if bank == null:
		self.bank = Node.new()
	return bank

func _container_set(value):
	if group_container != null:
		group_container.queue_free()
	group_container = value
	
func _container_get():
	if group_container == null:
		if starting_group_container:
			group_container = get_node(starting_group_container)
			starting_group_container = ""
		else:
			group_container = Node.new()
			group_container.name = self.name + "'s group container"
			get_parent().add_child(group_container)
	return group_container

func spawn(node_name, group_name=-1, position=null):
	if _bank_get().has_node(node_name):
		var n = bank.get_node(node_name).duplicate()
		var group = null
		if group_name != null:
			if group_name is int and group_name==-1: group_name=node_name+"s"
			if group_name is Node:
				group = group_name
			else:
				group = get_group(group_name)
			group.add_child(n)
		if position!=null: n.position = position
		emit_signal("spawned", n)
		return n
	else:
		print("NavdiBanker \""+self.name+"\" cannot spawn "+node_name+" (it was not found)")
	
func get_group(group_name) -> Node:
	if not self.group_container.has_node(group_name):
		var node = Node.new()
		node.set_name(group_name)
		self.group_container.add_child(node)
	return self.group_container.get_node(group_name)
	
func empty_group(group_name):
	var group = get_group(group_name)
	for i in range(group.get_child_count()):
		group.get_child(i).queue_free()
