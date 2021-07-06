class_name LumpyDictionary

var dict: Dictionary
func _init():
	dict = Dictionary()

func lump_add(key, single_item):
	if not dict.has(key):
		dict[key] = [single_item]
	elif not (single_item in dict[key]):
		dict[key].append(single_item)

func lump_remove(key, single_item):
	if dict.has(key) and single_item in dict[key]:
		dict[key].erase(single_item)
		
func lump_get_all(key):
	if dict.has(key):
		return dict[key]
	else:
		return []
		
# not allowed
func lump_find_key(_single_item):
	pass
