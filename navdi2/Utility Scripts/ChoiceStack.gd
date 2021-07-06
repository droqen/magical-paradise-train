class_name ChoiceStack

var tier_start_index = 0
var choices = []

func _init(arr = null):
	if arr:
		# warning-ignore:return_value_discarded
		add_array(arr)
		# warning-ignore:return_value_discarded
		lock_tier()
	
func add(item) -> ChoiceStack:
	choices.append(item)
	return self
	
func add_array(arr) -> ChoiceStack:
	for item in arr:
		# warning-ignore:return_value_discarded
		add(item)
	return self
	
func lock_tier() -> ChoiceStack:
	_shuffle(choices, tier_start_index)
	tier_start_index = len(choices)
	return self

func is_locked() -> bool:
	return tier_start_index == len(choices)
	
func remove_all(item) -> ChoiceStack:
	var i: int = 0
	while i >= 0:
		i = choices.find(item, i)
		if i >= 0:
			choices.remove(i)
			if i < tier_start_index:
				tier_start_index -= 1
	return self
				
func get_random():
	return choices[randi()%len(choices)]
	
func get_first_true(funcref_test_item, fail_return = null):
	for item in choices:
		if funcref_test_item.call_func(item):
			return item
	return fail_return
	
func get_highest(funcref_eval, fail_return = null, minimum_score = null):
	var bestItem = fail_return
	var bestEval = minimum_score
	for item in choices:
		var eval = funcref_eval.call_func(item)
		if bestEval == null or eval >= bestEval:
			bestItem = item
			bestEval = eval
	if minimum_score != null and bestEval != null:
		if bestEval < minimum_score: return fail_return
	return bestItem

func _shuffle(arr, start = 0, end = 0):
	if end <= 0:
		end = len(arr) + end
	for i in range(start + 1, end):
		var j = start + randi() % (i + 1 - start)
		var t = arr[i]
		arr[i] = arr[j]
		arr[j] = t
	return arr
