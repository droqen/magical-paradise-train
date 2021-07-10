extends KinematicBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var map=$"../State/NavdiBoardTileMap"
	var cell=map.world_to_map(position)
	position=map.map_to_center(cell)
	map._register(cell,self)
