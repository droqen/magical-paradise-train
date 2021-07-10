extends Node

onready var map=$"../State/NavdiBoardTileMap"

export(int)var ICE_TILE=10
export(int)var FLOOR_TILE=12
export(int)var WALL_TILE=11 # probably want to just check .solid somehow?
const ymin=-10
const ymax=9
const xmin=-10
const xmax=9

func _ready():
#	generate()
	pass

func generate():
	for y in range(ymin+1,ymax-1+1):
		for x in range(ymin+1,ymax-1+1):
			map.set_cell(x,y,ICE_TILE)
	for y in range(ymin,ymax+1):
		map.set_cell(xmin,y,WALL_TILE)
		map.set_cell(xmax,y,WALL_TILE)
	for x in range(xmin,xmax+1):
		map.set_cell(x,ymin,WALL_TILE)
		map.set_cell(x,ymax,WALL_TILE)
