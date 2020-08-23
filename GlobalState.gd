extends Node

onready var ui := $"/root/Game/UI" as UserInterface

var currentLevel := 2
var levels := {
	0: preload("res://Levels/Level0.tscn"),
	1: preload("res://Levels/Level1.tscn"),
	2: preload("res://Levels/Level2.tscn"),
	3: preload("res://Levels/Level3.tscn"),
	4: preload("res://Levels/Level4.tscn"),
	5: preload("res://Levels/TheEnd.tscn")
}

var levelNames := {
	0: "Starting area",
	1: "Temple of torment",
	2: "Chthonian caves",
	3: "Gauntlet",
	4: "Storage facility",
	5: ""
}

var isGameOver := false
var canProceedToNextLevel := false

func _ready():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -17)

func gameOver():
	if isGameOver:
		return
	
	isGameOver = true
	ui.gameOver()

func reset():
	if not levels.has(currentLevel):
		return

	var game := get_tree().root.get_node("Game")
	for child in game.get_children():
		if child is TileMap:
			child.queue_free()
			print_debug("Current level deleted: " + var2str(child.name))

	var level = levels[currentLevel].instance()
	game.add_child(level)
	ui.setLevelName(levelNames[currentLevel])
	ui.reset()
	isGameOver = false
	canProceedToNextLevel = false

func completeLevel():
	ui.get_node("Sound").play()
	get_tree().call_group(Guy.TEAM, "takeDamage", 100000)
	get_tree().call_group(Player.TEAM, "sleep")
	currentLevel += 1
	if levels.has(currentLevel):
		ui.nextLevel()
