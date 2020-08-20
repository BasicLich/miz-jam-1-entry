extends KinematicBody2D

class_name Actor

const GRAVITY := Vector2(0, 350)

var moveSpeed := 1.0
var initialJumpVel := 1.0

var maxHealth := 100
var health := 100
var deadAnimationNeeded = true

var vel := Vector2(0, 0)
var onFloor := false
var movement := Common.STAY
var weapons := [
	Weapon.WeaponType.GUN,
	Weapon.WeaponType.SHOTGUN,
	Weapon.WeaponType.SUBMACHINE_GUN
]

onready var w := $Weapon as Weapon

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	set_physics_process(true)

func _physics_process(delta):
	var moveControl := 1.0
	if onFloor:
		vel.y = 0
	if isDead():
		_runDeadAnimation()
	
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

	vel = move_and_slide(vel, Vector2(0, -1))
	onFloor = is_on_floor()

func _changeWeaponDirection(dir):
	w.dir = dir

func setAim(aim):
	w.aim = aim

func jump():
	if onFloor:
		vel.y = -initialJumpVel
		onFloor = false
		
func shoot(team: String):
	w.shoot(team)

func _findWeapon(current, d: int):
	var i := weapons.find(current) + d
	if i > weapons.size() - 1:
		i = 0
	elif i < 0:
		i = weapons.back()
	return weapons[i]

func nextWeapon():
	w.switchWeapon(_findWeapon(w.type, +1))
	
func prevWeapon():
	w.switchWeapon(_findWeapon(w.type, -1))

func setInitialHealth(value: int):
	health = value
	maxHealth = value

func takeDamage(value: int):
	health = max(0, health - value)
	
func isDead() -> bool:
	return health == 0
	
func _runDeadAnimation():
	if deadAnimationNeeded:
		deadAnimationNeeded = false
		onFloor = false
		vel = Vector2(rng.randf_range(-3, 3) * 25, -150)
		movement = Common.STAY
		w.hide()
