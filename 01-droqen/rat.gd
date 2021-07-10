extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var prev_global_pos = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if prev_global_pos != null:
		if global_position.x != prev_global_pos.x:
			$NavdiSheetSprite.flip_h = global_position.x < prev_global_pos.x
	
	prev_global_pos = global_position

	print("player alive ",randf())


func _on_rat_area_entered(area):
	area.queue_free()
	$get.play()
