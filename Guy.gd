extends Actor

class_name Guy

const TEAM := "Guy"
const TEAM_PROJECTILE := TEAM + "Projectile"
const SOCIAL_DISTANCE := 30.0
const NOT_INTERESTED := 800.0
const NEW_INTEREST := 1.0

var rnd = RandomNumberGenerator.new()
var target: Node2D
var lastSeen: Vector2
var lastDistance: float
var interest: float

onready var sprite := $Sprite as Sprite

func _ready():
	rnd.randomize()
	setInitialHealth(80)
	set_process(true)
	deathSounds = 5

#func _draw():
#	draw_circle(lastSeen - position, 2, Color(0, 120, 120))

func _enter_tree():
	add_to_group(TEAM)
	moveSpeed = 80.0
	initialJumpVel = 50.0

func _process(delta):
	sprite.modulate = color

	if isDead():
		return

	var targetVisible := _targetVisible()
	if targetVisible:
		interest = NEW_INTEREST
		lastSeen = target.position
		#update()

	if target == null or interest < 0:
		movement = Common.STAY
	else:
		if target.position.distance_to(position) > NOT_INTERESTED:
			target = null
			return

		var whereToGo := lastSeen
		if targetVisible:
			whereToGo = target.position

		if whereToGo and whereToGo.distance_to(position) > SOCIAL_DISTANCE:
			if abs(lastDistance - whereToGo.distance_to(position)) <= 0.01:
				interest = interest - delta
			lastDistance = whereToGo.distance_to(position)
			if abs(whereToGo.x - position.x) <= 3:
				movement = Common.STAY
			elif whereToGo.x > position.x:
				movement = Common.RIGHT
			elif whereToGo.x < position.x:
				movement = Common.LEFT
		else:
			movement = Common.STAY
		var needToShoot := false
		if targetVisible:
			if target.position.x > position.x - 5 and target.position.x < position.x + 5 and target.position.y < position.y:
				setAim(Common.UP)
				needToShoot = true
			elif target.position.x > position.x - 5 and target.position.x < position.x + 5 and target.position.y > position.y:
				setAim(Common.DOWN)
				needToShoot = true
			else:
				setAim(Common.STRAIGHT)
				if target.position.y > position.y - 6 and target.position.y < position.y + 6:
					needToShoot = true
		
		if needToShoot and rnd.randi_range(0, 1000) < 100:
			shoot(TEAM_PROJECTILE)
			
		if rnd.randi_range(0, 1000) < 10:
			jump()

func _targetVisible() -> bool:
	if target != null:
		var spaceState := get_world_2d().direct_space_state
		var intersectRes := spaceState.intersect_ray(position, target.position, [self], collision_mask)
		return intersectRes and intersectRes.collider == target
	else:
		return false

func _on_DetectionArea_body_entered(body: Node2D):
	if body.is_in_group(Player.TEAM):
		interest = NEW_INTEREST
		target = body
