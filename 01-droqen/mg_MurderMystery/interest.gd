extends NavdiMazeNobody
class_name Interest

const IsSolid = true
const IsInterest = true

export(String)var message
export(Array, String)var choices

func _ready():
	var _tilemap = $"../NavdiBoardTileMap"
	setup(_tilemap, _tilemap.world_to_map(position))

var _master

func select_choice(mmmmaster, choiceIndex):
	_master = mmmmaster
	_resolve_choice(choiceIndex)

func _resolve_choice(choiceIndex):
	_choice_exit()

func _choice_continue():
	_master.uinode.setup_appear(message, choices)
func _choice_pause():
	_master.set_mmode_locked()
func _choice_exit():
	_master.set_mmode_player()
