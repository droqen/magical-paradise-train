var brain:NavdiBrain = null

func get_yens():
	push_error("NavdiLobe %s: please override get_yens" % [get_script()])
	return []

func get_vol() -> int:
	push_error("NavdiLobe %s: please override get_vol" % [get_script()])
	return 0

func get_lobe(yen): # you may or may not want to use this. it just covers 'brain.get_lobe'.
	if brain == null:
		push_error("NavdiLobe %s: get_lobe failed; does not belong to a NavdiBrain")
		return null
	return brain.get_lobe(yen)
