extends Panel


export var voiceIndex : int = 0
signal PITCH_CHANGE
signal VOLUME_CHANGE
func _ready():
	call_deferred("SetSprite")
	$HBoxContainer/TextureRect/VolumeSlider.value = 0
	$HBoxContainer/TextureRect2/PitchSlider.value = 1
	
	
func SetSprite():
	$AnimatedSprite.frame = voiceIndex
	var _err
	_err = $HBoxContainer/TextureRect/VolumeSlider.connect("value_changed",self,"OnVolumeChange")
	_err = $HBoxContainer/TextureRect2/PitchSlider.connect("value_changed",self,"OnPitchChange")




func OnPitchChange(value):
	emit_signal("PITCH_CHANGE",value,voiceIndex)
	
	
func OnVolumeChange(value):
	emit_signal("VOLUME_CHANGE",value,voiceIndex)
