tool
extends NavdiMazeMaster
class_name NavdiFlagBackingMazeMaster

func get_cellvalue_flag(cellvalue):
	return get_parent().get_cellvalue_flag(cellvalue)

func _is_cellvalue_collision(cellvalue):
	return get_parent()._is_cellvalue_collision(cellvalue)
