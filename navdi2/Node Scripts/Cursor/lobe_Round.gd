extends Node

func modify_cursor_pos(pos):
	if pos == null: return null
	return Vector2(
		round(pos.x), round(pos.y)
	)
