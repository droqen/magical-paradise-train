extends Node

onready var music = $"../AudioStreamPlayer"
onready var ratbody = $"../State/guilty rat body"
onready var ratchat = $"../State/guilty rat body/MarchingTextContainer"
onready var guiltybutton = $"../State/back of your head/Control/h/Guilty"
onready var innocentbutton = $"../State/back of your head/Control/h/Innocent"
onready var continuebutton = $"../State/back of your head/Control/ContinueText"

#const starttimes = [0.0, 4.805, 9.592, 14.40, 18.6, ]
const starttimes = [0.0, 4.705, 9.492, 14.30, 18.5, ]
const stoptimes = [0.0, 3.5, 8.3, 13.25, 17.95, ]

var done = false
var fallhead = 0.0

var stoptime_index = 0

var bouncing_timer = 0

var rat_guilty = false
var rat_real_story
var rat_story = []
var rat_story_position = 0
var rat_truth = 0
var talker_volumes = [0,0]
var talker_pitches = [1,1]
var talker_animatednesses = [1,1]

func _ready():
	randomize()
	generate_rat_story()
	continuebutton.connect("pressed", self, "_on_click_continuebutton")
	innocentbutton.connect("pressed", self, "_on_click_judgementbutton", [false])
	guiltybutton.connect("pressed", self, "_on_click_judgementbutton", [true])

func generate_rat_story():
	var r:int
	
	r = randi() % 8
	match r:
		0:
			rat_guilty = true
			rat_story = [
				1, "So I was walking around",
				0, "and I saw this other rat",
				0, "and this other rat did the thing.",
				0, "Yeah, I love the rat cops.",
				1, "Can I go now?",
			]
			rat_real_story = "THIS RAT DID THE THING"
		1:
			rat_guilty = true
			rat_story = [
				0, "Lookit me, I'm an innocent rat. No doubt.",
				0, "I, uh, I'm late for an appointment!",
				0, "Jeez, nah, I'm, I'm just real nervous",
				0, "Didn't do nothin.",
				1, "So seriously, can I go now?",
			]
			rat_real_story = "THIS RAT IS NOT INNOCENT"
		2:
			rat_guilty = false
			rat_story = [
				1, "I didn't do it! C'mon!",
				1, "I, uh, I'm late for an appointment!",
				1, "So let's hurry this up yeah?",
				1, "Can I go now?",
			]
			rat_real_story = "THIS RAT REALLY IS JUST LATE FOR AN APPOINTMENT"
		3:
			rat_guilty = true
			rat_story = [
				1, "What? What's dis all about?",
				1, "You dink I am a crime rat?",
				1, "I will tell you if dat is drue.",
				1, "Yes, hee hee ha ha, I am crime rat.",
				0, "If you arrest, you will regret.",
				0, "I have rats in high places.",
			]
			rat_real_story = "DIS RAT IS A CRIME RAT"
		4:
			rat_guilty = true
			rat_story = [
				1, "Did I do the rat crime?",
				0, "Nah.",
				1, "Am I a crime rat?",
				0, "Nah!",
				1, "Now can I go already?",
			]
			rat_real_story = "THIS RAT DID THE RAT CRIME"
		5:
			rat_guilty = false
			rat_story = [
				1, "Did I do the rat crime?",
				1, "Nah.",
				1, "Am I a crime rat?",
				1, "Nah!",
				1, "Now can I go already?",
			]
			rat_real_story = "THIS RAT DID NOT DO THE RAT CRIME"
		6:
			rat_guilty = false
			rat_story = [
				1, "Don't arrest me please!",
				1, "I know I look terribly suspicious,",
				0, "but I'm a hardworking rat",
				0, "with a loving family",
				1, "and I did! not! do it!",
				1, "I'm very innocent!",
				1, "The most innocentest rat!",
				1, "Please!",
			]
			rat_real_story = "THIS RAT LIED BUT IS THE MOST INNOCENTEST"
		7:
			rat_guilty = false
			rat_story = [
				1, "I'm tellin' ya, I didn't do anything!",
				1, "The rat who done it, they went thattaway!",
				1, "Can I go now?",
				0, "I, uh, I'm late for an appointment!",
				1, "Jeez, nah, I'm, I'm just real nervous",
				1, "So seriously, can I go now?",
			]
			rat_real_story = "THIS INNOCENT RAT IS NOT LATE FOR AN APPOINTMENT"
	
	r = randi()%5
	match r:
		0:
			# primary tell: quieter
			talker_volumes[0] = rand_range(-8,-6)
			# secondary tell: less animated
			talker_animatednesses[0] = rand_range(0.7, 0.8)
		1:
			# primary tell: much slower/lower pitch
			talker_pitches[0] = rand_range(.55,.65)
			# secondary tell: none
		2:
			# primary tell: overanimated
			talker_animatednesses[0] = rand_range(1.3,1.6)
			# secondary tell: louder
			talker_volumes[0] = rand_range(1,2)
		3:
			# primary tell: much higher pitch
			talker_pitches[0] = rand_range(1.30,1.40)
			# secondary tell: quieter
			talker_volumes[0] = -1
		4:
			# tell: everything a bit more nervous, quiet, twitchy
			talker_pitches[0] = rand_range(1.10,1.20)
			talker_volumes[0] = rand_range(-3,-1.5)
			talker_animatednesses[0] = rand_range(1.10,1.20)
	
	# rat demeanours do vary slightly
	var pitch_variance = 0.2 * (randf()-randf())
	var animatedness_variance = 0.2 * (randf()-randf())
	var volume_variance = 3 * (randf()-randf())
	for i in range(2):
		talker_pitches[i] += pitch_variance
		talker_animatednesses[i] += animatedness_variance
		talker_volumes[i] += volume_variance

func _on_click_continuebutton():
	music.stop()
	rat_truth = rat_story[rat_story_position]
	ratchat.setup(rat_story[rat_story_position+1])
	ratbody_bounce()
	rat_story_position+=2
	if rat_story_position+1>=len(rat_story):
		continuebutton.disabled = true

func _process(delta):
	if done:
		fallhead += delta
		$"../State/back of your head".position.y += lerp(40, 80, fallhead) * delta
		
	if music.playing:
		if music.get_playback_position()+0.1 > starttimes[stoptime_index]:
			if (ratchat.is_done() or ratchat.is_paused()):
				music.stop()
				ratbody.bounce_cancel()
			stoptime_index += 1
		else:
			if music.get_playback_position()+0.25 > stoptimes[stoptime_index] and (ratchat.is_done() or ratchat.is_paused()):
				pass
			else:
				bouncing_timer += delta * music.pitch_scale
				if bouncing_timer >= 0.29:
					ratbody_bounce()
					bouncing_timer -= 0.3
			
	else:
		if not (ratchat.is_done() or ratchat.is_paused()):
			stoptime_index = randi()%4
			ratbody_playmusic()
			stoptime_index += 1

func ratbody_playmusic():
	music.volume_db = talker_volumes[rat_truth]
	music.pitch_scale = talker_pitches[rat_truth]
	music.play(starttimes[stoptime_index])

func ratbody_bounce():
	ratbody.bounce(talker_animatednesses[rat_truth])

func _on_click_judgementbutton(judgement):
	continuebutton.disabled = true
	innocentbutton.disabled = true
	guiltybutton.disabled = true
	ratbody.bounce_cancel()
	music.stop()
	ratchat.pause()
	done = true
	if judgement == rat_guilty:
		$"../State/ending".slam(rat_real_story, true) # win!
		yield($"../State/ending","finished")
		get_parent().emit_signal("player_won")
	else:
		$"../State/ending".slam(rat_real_story, false) # lose!
		yield($"../State/ending","finished")
		get_parent().emit_signal("player_lost")
