extends Node

enum{
	MMODE_PLAYER,
	MMODE_LOCKED,
	MMODE_UINODE,
}

var mmode

onready var uinode = $"../uinode"
onready var player = $"../detective_rat"
onready var cursor = $"../cursor"

var uinode_interestingTarget = null

func _ready():
	set_mmode_player()
	player.connect("touched", self, "_on_player_touched")
	uinode.connect("responded", self, "_on_uinode_responded")
	get_parent().connect("state_changed", self, "_on_state_changed")
func _on_state_changed():
	player.setup($"../State/NavdiBoardTileMap", $"../State/NavdiBoardTileMap".world_to_map(player.position))
	cursor.setup($"../State/NavdiBoardTileMap", player._cell)
	player.cancel_cursor()
func _on_player_touched(interestingTarget):
	uinode_interestingTarget = interestingTarget
	if mmode == MMODE_PLAYER:
		set_mmode_uinode()
		uinode.setup_appear(interestingTarget.message, interestingTarget.choices)
func _on_uinode_responded(response):
	if uinode_interestingTarget:
		uinode_interestingTarget.select_choice(self, response)
	else:
		set_mmode_player()
func set_mmode_locked():
	mmode = MMODE_LOCKED
#	player.cancel_cursor()
	_update_mmode()
func set_mmode_player():
	mmode = MMODE_PLAYER
	player.cancel_cursor()
	_update_mmode()
func set_mmode_uinode():
	mmode = MMODE_UINODE
	_update_mmode()
func _update_mmode():
	match mmode:
		MMODE_PLAYER:
			cursor.locked = false
			uinode.appearing = false
		MMODE_UINODE:
			cursor.locked = true
			uinode.appearing = true
			uinode.setup_appear("Debug", ["x",])
		MMODE_LOCKED:
			cursor.locked = true
			uinode.appearing = false
