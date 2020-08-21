extends Area2D

class_name Goal

onready var globalState = $"/root/GlobalState"


func _on_Goal_body_entered(body: Node2D):
	if body is Player:
		globalState.completeLevel()
