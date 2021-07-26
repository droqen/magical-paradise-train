extends AudioStreamPlayer



var pitchVariance = 0.2

var shouldPlaySound : bool = true
#flip this on and off to play soound every other step

func _ready():
	pass
	




func PlayWalkSound():
	shouldPlaySound = !shouldPlaySound
	if shouldPlaySound:
		var r = rand_range(-pitchVariance,pitchVariance)
		pitch_scale = 1 + r
		play()
