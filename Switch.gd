extends StaticBody2D

class_name Switch

export var state = Common.OFF

func _ready():
	_update()

func _update():
	$On.visible = state == Common.ON
	$Off.visible = state == Common.OFF

func toggle():
	if state == Common.ON:
		state = Common.OFF
	else:
		state = Common.ON
	_update()
