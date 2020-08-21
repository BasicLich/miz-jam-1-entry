extends CanvasLayer

class_name UserInterface

func _ready():
	reset()

func reset():
	$AnimationPlayer.play("Reset")

func gameOver():
	if $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation == "GameOver":
		return

	$AnimationPlayer.play("GameOver")

func nextLevel():
	if $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation == "LevelComplete":
		return

	$AnimationPlayer.play("LevelComplete")

func setHealth(value: int, maxValue: int):
	$PlayerHealth.max_value = maxValue
	$PlayerHealth.value = value
