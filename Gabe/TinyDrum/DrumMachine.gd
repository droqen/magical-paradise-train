extends Node2D

enum VOICES  {KICK, HAT,SNARE,CLAP}

var currentVoice : int = 0
var currentStep : int = 0
var maxSteps = 15

var sequence = [
	[],
	[],
	[],
	[]
]

func _ready():
	InitSteps()
	var _err
	_err = $StepButtons.connect("STEP_BUTTON_CHANGED",self,"OnStepButtonChanged")
	_err = $SoundButtons.connect("VOICE_CHANGED",self,"SetVoice")
	_err = $TempoTimer.connect("timeout",self,"TempoTimeout")
	
	var params = $VoiceParams/HBoxContainer.get_children()
	for c in params:
		c.connect("PITCH_CHANGE",self,"OnPitchChange")
		c.connect("VOLUME_CHANGE",self,"OnVolumeChange")
		
func InitSteps():
	for _i in range(16):
		sequence[VOICES.KICK].append(false)
		sequence[VOICES.HAT].append(false)
		sequence[VOICES.SNARE].append(false)
		sequence[VOICES.CLAP].append(false)

		

func SetVoice(newVoice):
	print("setting voice")
	currentVoice = newVoice
	
	$StepButtons.DisplayVoiceSteps(sequence[currentVoice])
			
func OnStepButtonChanged(buttonIndex,status):
	sequence[currentVoice][buttonIndex] = status
	print(sequence[currentVoice])
	
	
	
func TempoTimeout():
	$StepButtons.OnStep(currentStep)
		
	if sequence[VOICES.KICK][currentStep]:
		$SFX/Kick.play()
		
	if sequence[VOICES.SNARE][currentStep]:
		$SFX/Snare.play()
		
	if sequence[VOICES.HAT][currentStep]:
		$SFX/Hat.play()
		
	if sequence[VOICES.CLAP][currentStep]:
		$SFX/Clap.play()
		

	currentStep += 1
	if currentStep > maxSteps:
		currentStep = 0
		
func OnPitchChange(value,voiceIndex):
	print("pitch changed")
	match(voiceIndex):
		(VOICES.KICK):
			$SFX/Kick.pitch_scale = value
		(VOICES.SNARE):
			$SFX/Snare.pitch_scale = value
		(VOICES.HAT):
			$SFX/Hat.pitch_scale = value
		(VOICES.CLAP):
			$SFX/Clap.pitch_scale = value
	
	
func OnVolumeChange(value,voiceIndex):
		match(voiceIndex):
			(VOICES.KICK):
				$SFX/Kick.volume_db = value
			(VOICES.SNARE):
				$SFX/Snare.volume_db = value
			(VOICES.HAT):
				$SFX/Hat.volume_db = value
			(VOICES.CLAP):
				$SFX/Clap.volume_db = value
		
