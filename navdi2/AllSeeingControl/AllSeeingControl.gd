tool
extends Control
class_name AllSeeingControl
export(bool)var main_on_click = false
export(Vector2)var window_size = Vector2(1000,800)
func _process(_delta):
	if main_on_click:
		main_on_click = false
		make_main()
func make_main():
	randomize()
	anchor_right = 1
	anchor_bottom = 1
	margin_right = 0
	margin_bottom = 0
	if not has_node("MarginContainer"):
		var m = append_node(self, MarginContainer.new())
		m.anchor_right = 1
		m.anchor_bottom = 1
		var nvc = append_node(m, NavdiViewerWindow.new(), "NavdiViewerWindow")
		var m2 = append_node(nvc, MarginContainer.new())
		for dir in ['top','left','bottom','right']:
			m2.add_constant_override("margin_"+dir, -1) # margins of -1
		var cr = append_node(m2, ColorRect.new())
		cr.color = Color.black
		
	var set:NavdiSettings = $NavdiSettings if has_node("NavdiSettings") else append_node(self, NavdiSettings.new(), "NavdiSettings")
	set.project_name = "Unnamed Navdi Project (AllSeeingControl)"
	set.width = window_size.x
	set.height = window_size.y
	set.zoom = 1
	set.UI_stretch_mode = true
	set.apply_on_click = true
	set.bg_color = Color(randf(),randf(),randf())
		
func append_node(parent, node, nodename = null):
	if nodename: node.name = nodename
	parent.add_child(node)
	node.owner = parent.owner if parent.owner else parent
	return node
