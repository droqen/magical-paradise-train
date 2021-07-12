extends Interest
export(String,FILE)var goto_scene
func _ready():
	$NavdiSheetSprite.frames = [17]
func _resolve_choice(choiceIndex):
	if choices[choiceIndex] == "open":
		$NavdiSheetSprite.frames = [18,19,20,21,21,21,21,21,]
		_choice_pause()
		yield(get_tree().create_timer(0.3), "timeout")
		_master.player.lastMove = _cell - _master.player._cell
		_master.player._set_cell(_cell)
		yield(get_tree().create_timer(0.1), "timeout")
		_master.player.target_door_name = self.name
		var scene = load(goto_scene).instance()
		get_parent().get_parent().change_state(scene)
	_choice_exit()
