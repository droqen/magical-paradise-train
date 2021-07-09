extends Node2D

onready var wallet = $Wallet
export(Array, Texture) var textures
export var numberOfCards = 3
var lives = 2
onready var animator = $AnimationPlayer
onready var timer = $Timer

var pockets
var repeat = []
onready var subeTex = preload("res://delleloper&mer/assets/sube.png")
onready var itemScn = preload("res://delleloper&mer/card.tscn")

func _ready():
	randomize()
	pockets = wallet.get_children()
	var i = 1
	for p in pockets:
		p.connect("clicked",self,"finished")
	pockets.shuffle()
	var sube = itemScn.instance()
	sube.texture = subeTex
	sube.correct = true
	pockets[0].itemHolder.add_child(sube)
	for each in numberOfCards:
		var item = itemScn.instance()
		var texId = randi() % textures.size()
		while repeat.has(texId):
			texId = randi() % textures.size()
		item.texture = textures[texId]
		repeat.append(texId)
		pockets[i].itemHolder.add_child(item)
		i += 1
	get_parent().connect("game_start",self,"onGameStart")


func onGameStart():
	animator.play("trainArrive")
	yield(animator,"animation_finished")
	animator.play("show")
	yield(animator,"animation_finished")
	timer.start(4)

func finished(result):
	if result:
		for p in pockets:
				p.gameover = true
		yield(get_tree().create_timer(1.5),"timeout")
		get_parent().emit_signal("player_won")
	else:
		lives -= 1
		if lives <= 0:
			timer.stop()
			yield(get_tree().create_timer(1.2),"timeout")
			gameLost()


func gameLost():
	for p in pockets:
		p.gameover = true
	animator.play("trainStarts")
	yield(animator,"animation_finished")
	get_parent().emit_signal("player_lost")
