extends TextureButton


var active : bool = false


export var buttonIndex : int = 0

var normalSprite = "res://Gabe/TinyDrum/gfx/purple_step_button.png"
var accentSprite = "res://Gabe/TinyDrum/gfx/magenta_step_button.png"

signal BUTTON_CHANGED

func _ready():
	call_deferred("SetSprite")
	SetInactive()
	$FlashLight.hide()
	var _err = connect("pressed",self,"OnPressed")

func OnPressed():
	if active:
		SetInactive()
	else:
		SetActive()
	#only emit signal when button is actually pressed, SetActive and SetInactive can be called
	#from elsewhere
	emit_signal("BUTTON_CHANGED",buttonIndex,active)
	
func SetSprite():
	if buttonIndex == 0 || buttonIndex == 4 ||buttonIndex == 8 || buttonIndex == 12:
	
		texture_normal = load(accentSprite)


func SetActive():
	active = true
	$OnLight.show()
	
	
	
func SetInactive():
	active = false
	$OnLight.hide()
	
	
func Flash():
	$FlashLight.show()
	$FlashTimer.start()
	
	
