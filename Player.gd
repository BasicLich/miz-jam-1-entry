extends Actor

class_name Player

const TEAM := "Player"
const TEAM_PROJECTILE := TEAM + "Projectile"

onready var globalState = $"/root/GlobalState"
onready var ui := $"/root/Game/UI" as UserInterface

func _ready():
	set_process(true)
	setInitialHealth(130)
	_updateHealth()

func _enter_tree():
	add_to_group(TEAM)
	moveSpeed = 180.0
	initialJumpVel = 200.0

func _process(delta):
	if isDead():
		return

	if Input.is_action_pressed("player_left"):
		movement = Common.LEFT
	elif Input.is_action_pressed("player_right"):
		movement = Common.RIGHT
	else:
		movement = Common.STAY
	
	if Input.is_action_pressed("player_aim_up"):
		setAim(Common.UP)
	elif Input.is_action_pressed("player_aim_down"):
		setAim(Common.DOWN)
	else:
		setAim(Common.STRAIGHT)
	
	if Input.is_action_just_pressed("player_jump"):
		jump()
	
	if Input.is_action_pressed("player_shoot"):
		shoot(TEAM_PROJECTILE)

	if Input.is_action_just_pressed("player_next_weapon"):
		nextWeapon()
		
	if Input.is_action_just_pressed("player_prev_weapon"):
		prevWeapon()

func _updateHealth():
	ui.setHealth(health, maxHealth)

func takeDamage(value: int):
	.takeDamage(value)
	_updateHealth()
	
	if health == 0:
		globalState.gameOver()

func sleep():
	set_process(false)
	setAim(Common.STRAIGHT)
	movement = Common.STAY
