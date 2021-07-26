extends TextureButton





func _ready():
	pass # Replace with function body.


func OnTrackEnter(_body):
	if disabled == false:
		disabled = true
		#$AudioStreamPlayer.play()
	
