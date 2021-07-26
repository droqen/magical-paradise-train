extends Node2D


signal STEP_BUTTON_CHANGED
func _ready():
	call_deferred("ConnectButtons")
	
	
func ConnectButtons():
	var children = get_children()
	for c in children:
		c.connect("BUTTON_CHANGED",self,"OnStepButtonPressed")


func DisplayVoiceSteps(stepList : Array):
	print(stepList)
	for step in stepList.size():
		if stepList[step]:
			get_child(step).SetActive()
		else:
			get_child(step).SetInactive()
			
			
func OnStepButtonPressed(buttonIndex, buttonStatus):
	emit_signal("STEP_BUTTON_CHANGED",buttonIndex,buttonStatus)	
	print(buttonIndex)
	
func OnStep(stepNumber):
	get_child(stepNumber).Flash()
