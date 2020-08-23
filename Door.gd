extends Node2D

class_name Door

var states := []
var closed := true
onready var ap := $DoorBody/AnimationPlayer

func setState(state):
	states.push_back(state)
	updateDoor()

func updateDoor():
	if states.empty():
		return
		
	var state = states.pop_back()
	if state == Common.ON and closed:
		closed = false
		ap.play("Open")
		$Sound.play()
	elif not closed:
		closed = true
		ap.play_backwards("Open")
		$Sound.play()
