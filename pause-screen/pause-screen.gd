extends Control


var isPaused : bool = false

var authorSuffix = "By: "

func _ready():
	var _err = $ColorRect/PausedLabel/VBoxContainer/NextGameButton.connect("pressed",self,"NextGameButtonPressed")
	OnPauseChange()

func _input(event):
	if Input.is_action_just_pressed("pause"):
		if Global.is_microgame_playing == false:
			return
			
		isPaused = !isPaused
		OnPauseChange()
		
func OnPauseChange():
	if isPaused:
		RandomizeColor()
		show()
		get_tree().paused = true
		
		var mg : MicrogameMetadata = Global.current_microgame_md
		var title = $ColorRect/PausedLabel/VBoxContainer/TitleLabel
		var author = $ColorRect/PausedLabel/VBoxContainer/AuthorLabel
		var desc = $ColorRect/PausedLabel/VBoxContainer/DescriptionLabel
		
		title.text = mg.microgame_name
		author.text = authorSuffix + mg.author_name
		desc.text = mg.microgame_description

	else:
		hide()
		get_tree().paused = false
	
func RandomizeColor():
	var h = randf()
	var s = rand_range(.3,.5)
	var v = rand_range(.8,1)
	
	var col = Color.from_hsv(h,s,v,.69)
	$ColorRect.color = col

func NextGameButtonPressed():
	Global.emit_signal("SKIP_REQUESTED")
	isPaused = false
	OnPauseChange()
