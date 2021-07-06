class_name NavdiSorter
static func numarray_get_highest_index(numarray):
	var highest_value=null
	var found_at_index=-1
	for i in range(len(numarray)):
		if highest_value==null:
			highest_value=numarray[i]
			found_at_index=i
		elif highest_value<numarray[i]:
			highest_value=numarray[i]
			found_at_index=i
	return found_at_index
