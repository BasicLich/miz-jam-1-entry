extends KinematicBody2D

class_name Actor

const GRAVITY := Vector2(0, 350)

export var moveSpeed := 1.0
export var initialJumpVel := 1.0

var vel := Vector2(0, 0)
var onFloor := false
var movement := Common.STAY

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	var moveControl := 1.0
	if onFloor:
		vel.y = 0
	if movement == Common.LEFT:
		if vel.x > 0:
			moveControl = 3.7
		vel.x = max(vel.x - moveSpeed * moveControl * delta, -moveSpeed)
		_changeWeaponDirection(movement)
	elif movement == Common.RIGHT:
		if vel.x < 0:
			moveControl = 3.7
		vel.x = min(vel.x + moveSpeed * moveControl * delta, +moveSpeed)
		_changeWeaponDirection(movement)
	elif onFloor:
		vel.x = vel.x * delta

	vel = vel + GRAVITY * delta
	
	move_and_slide(vel, Vector2(0, -1))
	onFloor = is_on_floor()


func _changeWeaponDirection(dir):
	var w := $Weapon as Node2D
	if w == null:
		return

	w.dir = dir

func setAim(aim):
	var w := $Weapon as Node2D
	if w == null:
		return
	w.aim = aim

func jump():
	if onFloor:
		vel.y = -initialJumpVel
		onFloor = false
		
func shoot():
	var w := $Weapon as Node2D
	if w == null:
		return
	
	w.shoot()
