extends Node

onready var globalState = $"/root/GlobalState" as GlobalState

func _ready():
	globalState.reset()
	set_process_input(true)

func _input(event: InputEvent):
	if event.is_action_pressed("restart_level"):
		globalState.reset()
		
	if event is InputEventKey and globalState.canProceedToNextLevel:
		globalState.reset()

func allowNextLevel():
	globalState.canProceedToNextLevel = true
