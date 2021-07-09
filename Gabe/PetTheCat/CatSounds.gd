extends AudioStreamPlayer


var purrs = [
	"res://Gabe/sfx/CatPurrs/cat_purr-01.wav",
	"res://Gabe/sfx/CatPurrs/cat_purr-02.wav",
	"res://Gabe/sfx/CatPurrs/cat_purr-03.wav",
	"res://Gabe/sfx/CatPurrs/cat_purr-04.wav",
	"res://Gabe/sfx/CatPurrs/cat_purr-05.wav",
	"res://Gabe/sfx/CatPurrs/cat_purr-06.wav",
]


func PlayCatPurr():
	var purrSound = purrs[randi() % purrs.size()]
	stream = load(purrSound)
	play()
