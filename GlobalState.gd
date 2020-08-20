extends Node

onready var ui := $"/root/Game/UI" as UserInterface

var currentLevel := 0
var levels := {
	0: preload("res://Level0.tscn")
}
var isGameOver := false

func gameOver():
	if isGameOver:
		return
	
	isGameOver = true
	ui.gameOver()

func reset():
	var game := get_tree().root.get_node("Game")
	for child in game.get_children():
		if child is TileMap:
			child.queue_free()
			print_debug("Current level deleted: " + var2str(child.name))

	var level = levels[currentLevel].instance()
	game.add_child(level)
	ui.reset()
	isGameOver = false
