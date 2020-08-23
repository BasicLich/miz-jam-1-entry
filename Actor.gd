extends KinematicBody2D

class_name Actor

const GRAVITY := Vector2(0, 350)
const HURT_COLOR := Color.red
const NORMAL_COLOR := Color.white
var color := NORMAL_COLOR

var moveSpeed := 1.0
var initialJumpVel := 1.0

var maxHealth := 100
var health := 100
var deadAnimationNeeded = true
var hurtAnim := 0.0

var vel := Vector2(0, 0)
var onFloor := false
var movement := Common.STAY
var weapons := [
	Weapon.WeaponType.GUN
]

onready var w := $Weapon as Weapon
onready var ap := $AnimationPlayer as AnimationPlayer

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	set_physics_process(true)

func _physics_process(delta):
	if hurtAnim > 0:
		hurtAnim = max(0, hurtAnim - delta * 5)
		color.r = lerp(NORMAL_COLOR.r, HURT_COLOR.r, hurtAnim)
		color.g = lerp(NORMAL_COLOR.g, HURT_COLOR.g, hurtAnim)
		color.b = lerp(NORMAL_COLOR.b, HURT_COLOR.b, hurtAnim)

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

	if not isDead():
		if movement != Common.STAY and not ap.is_playing():
			ap.play("Walk")
		elif (movement == Common.STAY or not onFloor) and ap.is_playing():
			ap.stop()

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
		i = weapons.size() - 1
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
	hurtAnim = 1.0
	
func isDead() -> bool:
	return health == 0
	
func _runDeadAnimation():
	if deadAnimationNeeded:
		deadAnimationNeeded = false
		onFloor = false
		vel = Vector2(rng.randf_range(-3, 3) * 25, -150)
		movement = Common.STAY
		if rng.randi_range(0, 10) > 5:
			ap.play("Death")
		else:
			ap.play("Death2")
		w.hide()
		#Ehm... Need to figure ot better way of handling this.
		set_collision_layer_bit(1, false)
		set_collision_layer_bit(2, false)
		set_collision_layer_bit(5, true)
		set_collision_mask_bit(1, false)
		set_collision_mask_bit(2, false)

func heal(value: int) -> bool:
	if health < maxHealth:
		health = min(health + value, maxHealth)
		return true
	else:
		return false

func addWeapon(value) -> bool:
	if weapons.find(value) != -1:
		return false
	else:
		weapons.append(value)
		return true
