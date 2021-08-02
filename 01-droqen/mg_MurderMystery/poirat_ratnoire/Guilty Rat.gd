extends Sprite

onready var head = $"guilty rat head"

var target_head_scale: Vector2 = Vector2.ONE
var target_head_rot: float = 0

func _process(_delta):
#	if ($MarchingTextContainer.is_done() or $MarchingTextContainer.is_paused()):
#		target_head_scale = Vector2.ONE
#		target_head_rot = 0
#	else:
#		chitchat -= _delta
#	if chitchat < 0:
#		chitchat += 0.30
	head.scale = lerp(head.scale, target_head_scale, 0.35)
	head.rotation = lerp(head.rotation, target_head_rot, 0.35)
	target_head_scale = lerp(target_head_scale, Vector2.ONE, 0.05)
	target_head_rot = lerp(target_head_rot, 0, 0.05)

func bounce_cancel():
	target_head_scale = Vector2.ONE
	target_head_rot = 0

func bounce(power = 1.0):
	target_head_scale = generate_bounce_scale() * power
	target_head_rot = (randf()-randf())*0.25 * power

func generate_bounce_scale():
	var bs = Vector2(rand_range(1.1,1.2),rand_range(1.1,1.2))
	if randf() < 0.5:
		bs.x = rand_range(0.8,1.1)
	else:
		bs.y = rand_range(0.8,1.1)
		bs.x = rand_range(1.3,1.5)
	return bs
