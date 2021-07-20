extends Node2D

onready var tween = $Tween
onready var explain = $Explain
onready var panel = self

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	explain.text = ""
	pass
	
func _write_instructions():
	explain.text = ""
	yield(get_tree().create_timer(0.8), "timeout")
	explain.text = "S"
	yield(get_tree().create_timer(0.05), "timeout")
	explain.text = "SC"
	yield(get_tree().create_timer(0.05), "timeout")
	explain.text = "SCR"
	yield(get_tree().create_timer(0.05), "timeout")
	explain.text = "SCRA"
	yield(get_tree().create_timer(0.05), "timeout")
	explain.text = "SCRAT"
	yield(get_tree().create_timer(0.05), "timeout")
	explain.text = "SCRATC"
	yield(get_tree().create_timer(0.05), "timeout")
	explain.text = "SCRATCH"
	yield(get_tree().create_timer(0.5), "timeout")
	explain.text = "SCRATCH!"
	yield(get_tree().create_timer(0.05), "timeout")
	explain.text = "SCRATCH!!"
	yield(get_tree().create_timer(1), "timeout")
	explain.text = "SCRATCH!!\n\n (carefully)"
	yield(get_tree().create_timer(0.7), "timeout")
	emit_signal("start_game")
	#queue_free()
	$Tween.interpolate_property(self, "position", self.position, self.position - Vector2(0, -160), .5, Tween.TRANS_CUBIC,Tween.EASE_IN)
	$Tween.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
