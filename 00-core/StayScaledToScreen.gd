extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var default_viewport_size = get_viewport().size
onready var default_scale = scale
onready var default_position = position
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mult = get_viewport().size / default_viewport_size
	position = default_position * mult
	scale = default_scale * mult
