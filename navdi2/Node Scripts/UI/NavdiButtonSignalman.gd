extends Node

class_name NavdiButtonSignalman

signal button_pressed(button)

export(NodePath)var buttons_container = "." # self

var buttons = []
var _watchers = []

func _ready():
	for button in get_node(buttons_container).get_children():
		if button is Button:
			buttons.append(button)
			_watchers.append(ButtonWatcher.new(button, self))

#func on_button_pressed(button: Button):
#	print(button.text)

class ButtonWatcher:
	var button:Button
	var parent
	func _init(_button:Button, _parent):
		button = _button
		parent = _parent
		button.connect("pressed", self, "_on_button_pressed")
	func _on_button_pressed():
		parent.emit_signal("button_pressed", button)
