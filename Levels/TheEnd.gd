extends TileMap

onready var globalState = $"/root/GlobalState"
onready var ui := $"/root/Game/UI" as UserInterface
onready var player := $Player as Player

func _ready():
	player.sleep()
	$AnimationPlayer.play("FinalText")

func showGameCompleteTitle():
	ui.gameComplete()
	globalState.currentLevel = 0
