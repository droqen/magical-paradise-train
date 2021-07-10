extends Area2D

var mouseIn
#onready var tw :Tween = $Tween
onready var itemHolder = $item
var gameover = false

signal clicked

func _input(event):
	if event is InputEventMouseButton and mouseIn == true and event.is_pressed():
		click()

func click():
	if gameover: return
	if $item.get_child_count() > 0:
		var item = $item.get_child(0)
		item.material = null
		$AnimationPlayer.play("Slide")
		emit_signal("clicked",$item.get_child(0).correct)
		if !$item.get_child(0).correct:
			yield(get_tree().create_timer(1.2),"timeout")
			if randf() > 0.5:
				$AnimationPlayer.play("fly2")
			else:
				$AnimationPlayer.play("fly")



func _on_Pocket_area_entered(area):
	if area.name == "pointer":
		mouseIn = true

func _on_Pocket_area_exited(area):
	if area.name == "pointer":
		mouseIn = false

