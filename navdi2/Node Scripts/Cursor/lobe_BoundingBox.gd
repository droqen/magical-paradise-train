extends Node

export(Rect2)var bounding_rect = Rect2(-1000,-1000,4000,4000)
export(int)var margin_left = 0
export(int)var margin_right = 0
export(int)var margin_top = 0
export(int)var margin_bottom = 0
export(int)var margin_scale = 1

export(bool)var null_when_outside = false
export(bool)var only_null_when_not_held = false

export(bool)var clamp_when_outside = true

func modify_cursor_pos(pos):
	if pos == null: return null
	var clamped_pos = Vector2(
		clamp(
			pos.x,
			bounding_rect.position.x + margin_left * margin_scale,
			bounding_rect.position.x + bounding_rect.size.x - margin_right * margin_scale
		),
		clamp(
			pos.y,
			bounding_rect.position.y + margin_top * margin_scale,
			bounding_rect.position.y + bounding_rect.size.y - margin_bottom * margin_scale
		)
	)
	if null_when_outside and clamped_pos != pos:
		if only_null_when_not_held and get_parent().get_held_mouse_pos() != null:
			pass
		else:
			return null
	if clamp_when_outside: return clamped_pos
	return pos
