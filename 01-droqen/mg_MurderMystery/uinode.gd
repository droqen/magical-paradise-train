extends Node2D

signal responded(response)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var buttonmaster = $"ui/choicewindow/MarginContainer/CenterContainer/buttonmaster"
var appearing = false

func _ready():
	modulate.a = 0
	position.y = 20
	for i in range(3):
#		buttonmaster.get_child(i).connect(
#			"pressed",self,"emit_signal",["responded", i])
		buttonmaster.get_child(i).connect(
			"pressed",self,"_on_button_pressed",[buttonmaster.get_child(i), i])
	$"ui/textwindow/AdvanceTextButton".connect(
		"pressed",
		$"ui/textwindow/MarchingTextContainer",
		"set_position_end")

func _on_button_pressed(button, i):
	if appearing:
		emit_signal("responded", i)

func setup_appear(text,choices):
	appearing = true
	$"ui/textwindow/MarchingTextContainer".setup(text)
	for i in 3:
		var b = buttonmaster.get_child(i)
		if i < len(choices):
			b.show()
			b.text = choices[i]
		else:
			b.hide()
	return self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if appearing:
		modulate.a = lerp(modulate.a, 1, 0.2)
		position.y = lerp(position.y, 0, 0.2)
		if modulate.a > 0.5: 
			for button in buttonmaster.get_children():
				button.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		for button in buttonmaster.get_children():
			button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		modulate.a = lerp(modulate.a, 0, 0.2)
		position.y = lerp(position.y, 20, 0.2)
