extends TextureButton

var active : bool = false

export var buttonIndex : int = 0

signal VOICE_CHANGED
func _ready():
	
	SetInactive()
	call_deferred("Init")
	
	var _err = connect("pressed",self,"OnPressed")
	$AnimatedSprite.frame = buttonIndex

func OnPressed():
	if active:
		SetInactive()
	else:
		SetActive()
		
	emit_signal("VOICE_CHANGED",buttonIndex)

func Init():
	if buttonIndex == 0:
		SetActive()

func SetActive():
	active = true
	$OnLight.show()
	
	
func SetInactive():
	active = false
	$OnLight.hide()
