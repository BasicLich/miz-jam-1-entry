extends KinematicBody2D

const GRAVITY := Vector2(0, 350)
const MOVE_SPEED := 180.0
const INITIAL_JUMP_VEL := 200.0

var vel := Vector2(0, 0)
var onFloor := false

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	var moveControl := 1.0
	if onFloor:
		vel.y = 0
	if Input.is_action_pressed("player_left"):
		if vel.x > 0:
			moveControl = 3.7
		vel.x = max(vel.x - MOVE_SPEED * moveControl * delta, -MOVE_SPEED)
	elif Input.is_action_pressed("player_right"):
		if vel.x < 0:
			moveControl = 3.7
		vel.x = min(vel.x + MOVE_SPEED * moveControl * delta, +MOVE_SPEED)
	elif onFloor:
		vel.x = vel.x * delta

	vel = vel + GRAVITY * delta
	
	if onFloor and Input.is_action_just_pressed("player_jump"):
		vel.y = -INITIAL_JUMP_VEL
	
	move_and_slide(vel, Vector2(0, -1))
	onFloor = is_on_floor()
	var l := $"../UI/Label" as Label
	l.text = "vel: " + var2str(vel)
