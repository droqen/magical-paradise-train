tool
extends MarginContainer
class_name MarchingTextContainer

signal char_marched(c)
signal finished()

export(bool)var set_to_zero_on_ready = true
export(bool)var start_playing_on_ready = true

export(String, MULTILINE)var bbcode_text setget _set_bbcode_text, _get_bbcode_text
func _set_bbcode_text(_bbcode_text):
	if has_node('RichTextLabel'):
		$RichTextLabel.bbcode_text = _bbcode_text
		_char_count = len($RichTextLabel.text)
	
func _get_bbcode_text():
	if has_node('RichTextLabel'):
		return $RichTextLabel.bbcode_text

export(float)var base_delay_dur = 0.10

export(float)var short_delay_dur = 0.20
export(String)var short_delay_chars = "!,"

export(float)var long_delay_dur = 0.50
export(String)var long_delay_chars = ".?"

var _next_char_position: int = 0
onready var _char_delay: float = base_delay_dur
var _pending_char_delay: float = 0
var _char_count
var _paused
var _skip_first_process

func setup(_bbcode_text, start_playing = true):
	self.bbcode_text = _bbcode_text
	self.set_position_start()
	if start_playing: self.resume()
	else: self.pause()
	return self

func is_paused():
	return _paused
func is_done():
	return _next_char_position >= _char_count
func pause():
	_paused = true
	_char_delay = base_delay_dur
func resume():
	_paused = false
func resume_nodelay():
	_paused = false
	_char_delay = 0
func set_position_start():
	_next_char_position = 0
	_char_delay = base_delay_dur
	_pending_char_delay = 0
	$RichTextLabel.visible_characters = 0
func get_next_character():
	return $RichTextLabel.text[_next_char_position]
func march(emit = true):
	var c = get_next_character()
	_next_char_position += 1
	if c != '\n':
		$RichTextLabel.visible_characters += 1
	if emit and is_char_visible(c):
		emit_signal("char_marched", c)
	return c
func set_position_end():
	for _i in range(_char_count - _next_char_position):
		march(false)
	pause()
#	if not is_done():
#		_next_char_position = _char_count
#		$RichTextLabel.visible_characters = -1
#		emit_signal("finished")
#		pause()

func get_char_delay(c):
	var delay = base_delay_dur
	if long_delay_chars.find(c) >= 0:
		delay = long_delay_dur
	elif short_delay_chars.find(c) >= 0:
		delay = short_delay_dur
	if delay < _pending_char_delay:
		var diff = _pending_char_delay - delay
		_pending_char_delay = delay
		return base_delay_dur + diff
	else:
		_pending_char_delay = delay
		return base_delay_dur
func is_char_visible(c):
	match c:
		' ', '\t', "\n":
			return false
		_:
			return true

func _ready():
	_skip_first_process = true
	if not Engine.editor_hint and set_to_zero_on_ready:
		_char_count = len($RichTextLabel.text) # just in case
		set_position_start()
		if start_playing_on_ready: resume()
		else: pause()
		
func _process(delta):
	if not Engine.editor_hint:
		if _skip_first_process:
			delta = 0
			_skip_first_process = false 
		if not _paused:
			_char_delay -= delta
			if is_done():
				pause()
			else: while _char_delay < 0 and not is_done():
				# "march" advances the container inexorably towards is_done()=true.
				march()
				if is_done():
					emit_signal("finished")
					pause()
				else:
					_char_delay += get_char_delay(get_next_character())
