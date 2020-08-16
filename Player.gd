extends Actor

func _ready():
	set_process(true)

func _enter_tree():
	moveSpeed = 180.0
	initialJumpVel = 200.0

func _process(delta):
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
		shoot()
		
	if Input.is_action_just_pressed("player_next_weapon"):
		nextWeapon()
		
	if Input.is_action_just_pressed("player_prev_weapon"):
		prevWeapon()
