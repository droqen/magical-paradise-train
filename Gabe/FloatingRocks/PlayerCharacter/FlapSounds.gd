extends AudioStreamPlayer


var flapSFX = [
	"res://Gabe/FloatingRocks/sfx/flapwhoosh-01.wav",
	"res://Gabe/FloatingRocks/sfx/flapwhoosh-02.wav",
	"res://Gabe/FloatingRocks/sfx/flapwhoosh-03.wav",
	"res://Gabe/FloatingRocks/sfx/flapwhoosh-04.wav",
	"res://Gabe/FloatingRocks/sfx/flapwhoosh-05.wav",
]


var pitchVariance = 0.1

var shouldPlaySound : bool = true
#flip this on and off to play soound every other step





func PlayFlapSound():
	
	shouldPlaySound = !shouldPlaySound
	if shouldPlaySound:
		var sound = flapSFX[randi()%flapSFX.size()]
		stream = load(sound)
		var r = rand_range(-pitchVariance,pitchVariance)
		pitch_scale = 1 + r
		play()
