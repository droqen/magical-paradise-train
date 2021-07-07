extends Node2D

signal doors_opened

var state = "riding";
var current_animation;

func _process(_delta):
	if state == "doors_opening":
		$DoorAnimations.play("DoorsOpening");
		yield($DoorAnimations, "animation_finished");
		emit_signal("doors_opened");
		state = "doors_open";
	
	if state == "doors_closing":
		$DoorAnimations.play("DoorsOpening", -1, -1.0, true);
		yield($DoorAnimations, "animation_finished");
		state = "riding";
	
	if state == "riding":
		$DoorAnimations.play("CarRiding");

func open_doors():
	state = "doors_opening";

func close_doors():
	state = "doors_closing";
