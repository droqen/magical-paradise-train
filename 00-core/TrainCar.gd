extends Node2D

signal doors_opened

var state = "riding";
var current_animation;

func _process(_delta):
	if state == "riding" && !$CarRiding.is_playing():
		if $DoorsOpening.is_playing():
			$DoorsOpening.stop();

		$CarRiding.play();
	
	if state == "doors_opening":
		if $CarRiding.is_playing():
			$CarRiding.stop();
		
		if !$DoorsOpening.is_playing():
			$DoorsOpening.play("DoorsOpening");
			$DoorsOpening.connect("animation_finished", self, "_on_finished_doors_opening", [], CONNECT_ONESHOT);
	
	if state == "doors_open":
		$DoorsOpening.stop();
	
	if state == "doors_closing":
		if !$DoorsOpening.is_playing():
			$DoorsOpening.play_backwards("DoorsOpening");
			$DoorsOpening.connect("animation_finished", self, "_on_finished_doors_closing", [], CONNECT_ONESHOT);

func start_riding():
	state = "doors_riding"

func close_doors():
	state = "doors_closing"

func open_doors():
	state = "doors_opening"

func _on_finished_doors_closing():
	self.start_riding();

func _on_finished_doors_opening():
	state = "doors_open";
	emit_signal("doors_opened");
