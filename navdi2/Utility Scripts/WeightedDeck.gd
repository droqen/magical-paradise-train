class_name WeightedDeck

var items = []
var item_count = 0
var weights = []
var order = []
var total_weight = 0

func _init():
	pass

func add(weight, item):
	total_weight += weight
	for i in range(item_count):
		if items[i] == item: # if item has already been added, stack weights.
			weights[i] += weight
			return
	weights.append(weight)
	items.append(item)
	item_count += 1

func shuffle():
	self.order = []
	
	var flat_order = range(item_count)
	var flats_left = len(flat_order)
	var wmax = total_weight
	while flats_left > 0:
		# choose one out of flat_order
		var removed = false
		var w = wmax * randf()
		for i in range(flats_left):
			w -= self.weights[i]
			if w <= 0:
				self.order.append(flat_order[i])
				flat_order.remove(i)
				removed = true
				break
		if not removed:
			self.order.append(flat_order.pop_front())
		flats_left -= 1
		
	print(self.order)
	
func is_poppable():
	return len(order) > 0

func pop():
	if len(self.order) > 0:
		return items[self.order.pop_front()]
	else:
		return null
