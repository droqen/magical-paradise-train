extends Interest
func _resolve_choice(choiceIndex):
	if choices[choiceIndex] == "shoot":
		queue_free()
	_choice_exit()
