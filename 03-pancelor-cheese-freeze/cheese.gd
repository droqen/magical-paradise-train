extends KinematicBody2D

var cell: Vector2

onready var map=$"../State/NavdiBoardTileMap"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_cell(map.world_to_map(position))

func set_cell(v: Vector2):
	map._unregister(cell,self)
	cell=v
	map._register(cell,self)
	position=map.map_to_center(cell)
	
