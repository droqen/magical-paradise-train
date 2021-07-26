extends Node

var tween : Tween


func _ready():
	tween = Tween.new()
	add_child(tween)


func FadeOut():

	var target = get_parent()
	tween.interpolate_property(target, "volume_db", target.volume_db, -20,  1.5, Tween.TRANS_SINE , Tween.EASE_IN, 0)
	tween.start()



