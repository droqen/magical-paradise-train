extends Node2D

signal finished

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.connect("animation_finished", self, "_on_finished")
	hide()
	modulate.a = 0
	rotation = rand_range(-.05,.05)
	$fff2.rotation = rand_range(-.05,.05)
	$fff.rotation = rand_range(-.05,.05)
func _on_finished(animation_name):
	emit_signal("finished")
func slam(message: String, winner: bool):
	show()
	$AnimationPlayer.play("SLAM")
	$Label2.text = message
func _process(delta):
	if visible and not $AnimationPlayer.is_playing():
		return
		modulate.r -= delta
		modulate.g -= delta
		modulate.b -= delta
		position.y += lerp(100,0,modulate.r) * delta

func hit_ground():
	$CPUParticles2D.emitting = true
	$CPUParticles2D.set_pre_process_time(0.2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
