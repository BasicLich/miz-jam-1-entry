extends KinematicBody2D

class_name Actor

const GRAVITY := Vector2(0, 350)

export var moveSpeed := 1.0
export var initialJumpVel := 1.0

enum {LEFT, RIGHT, STAY}

var vel := Vector2(0, 0)
var onFloor := false
var movement := STAY

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	var moveControl := 1.0
	if onFloor:
		vel.y = 0
	if movement == LEFT:
		if vel.x > 0:
			moveControl = 3.7
		vel.x = max(vel.x - moveSpeed * moveControl * delta, -moveSpeed)
	elif movement == RIGHT:
		if vel.x < 0:
			moveControl = 3.7
		vel.x = min(vel.x + moveSpeed * moveControl * delta, +moveSpeed)
	elif onFloor:
		vel.x = vel.x * delta

	vel = vel + GRAVITY * delta
	
	if onFloor and Input.is_action_just_pressed("player_jump"):
		vel.y = -initialJumpVel
	
	move_and_slide(vel, Vector2(0, -1))
	onFloor = is_on_floor()
