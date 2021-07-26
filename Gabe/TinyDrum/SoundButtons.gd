extends Node2D


signal VOICE_CHANGED

func _ready():
	var _err
	var children = get_children()
	for c in children:
		c.connect("VOICE_CHANGED",self,"OnVoiceChange")

func OnVoiceChange(newVoice):
	emit_signal("VOICE_CHANGED",newVoice)
	var children = get_children()
	for c in children:
		if c.buttonIndex == newVoice:
			c.SetActive()
		else:
			c.SetInactive()
			
			
