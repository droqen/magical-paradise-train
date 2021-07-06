class_name NavdiBrain

var _yen_lobe_singles:Dictionary = Dictionary()
var _yen_lobe_library:LumpyDictionary = LumpyDictionary.new()

func clear():
	_yen_lobe_singles.clear()
	_yen_lobe_library.dict.clear()

func register_lobes(lobes):
	for lobe in lobes: register_lobe(lobe)
func register_lobe(lobe):
	if lobe.has_method("get_yens") and lobe.has_method("get_vol"):
		lobe.brain = self # will this work?
		for yen in lobe.get_yens():
			acknowledge_yen_lobe(yen, lobe)
	else:
		push_error("REJECTED LOBE '%s' %s (%s): it must implement both methods 'get_yens' and 'get_vol'"
		% [str(lobe), lobe.get('name'), lobe.get_path() if lobe.has_method("get_path") else str(lobe.get_script()),])

func acknowledge_yen_lobe(yen, lobe):
	_yen_lobe_library.lump_add(yen, lobe)
	if len(_yen_lobe_library.lump_get_all(yen)) == 1:
		_yen_lobe_singles[yen] = lobe
	elif yen in _yen_lobe_singles:
		_yen_lobe_singles.erase(yen)

func try_call_lobe(yen, method, params):
	var lobe = get_lobe(yen)
	if lobe:
		lobe.call(method, params)
		return true
	else:
		return false

func has_lobe(yen):
	return yen in _yen_lobe_library.dict

# do this in a more efficient way
func get_lobe(yen):
	if yen in _yen_lobe_singles:
		return _yen_lobe_singles[yen] # ignore volume: you're the only one :p
	
	var min_vol: int
	var loudest_lobe = null
	for lobe in _yen_lobe_library.lump_get_all(yen): # empty array if key not found
		var lobe_vol = lobe.get_vol()
		if min_vol <= lobe_vol or loudest_lobe == null:
			min_vol = lobe_vol
			loudest_lobe = lobe
	return loudest_lobe

func get_all_lobes(yen):
	return _yen_lobe_library.lump_get_all(yen)

func catscan():
	print(_yen_lobe_library.dict)
