extends Area2D

var active : bool = false
export var groupIndex = 0
export var leaveDir : Vector2 = Vector2.DOWN

signal BIRDS_SCARED

func _ready():
	var _err = connect("body_entered",self,"OnEnter")
	SetActive()


func IsBirdGroup():
	pass

	
func SetActive():
	active = true
	show()
	
	
	
func SetInactive():
	active = false
	hide()
	
	
	
func OnEnter(_body):
	if active:
		active = false
		$AudioStreamPlayer.play()
		emit_signal("BIRDS_SCARED")
		var birds = $Birds.get_children()
		for b in birds:
			b.GetScared(leaveDir)
