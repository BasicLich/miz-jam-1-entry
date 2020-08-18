extends Actor

class_name Guy

const TEAM := "Guy"
const TEAM_PROJECTILE := TEAM + "Projectile"
const SOCIAL_DISTANCE := 30.0
const NOT_INTERESTED := 800.0

var rnd = RandomNumberGenerator.new()
var target: Node2D

func _ready():
	rnd.randomize()
	set_process(true)

func _enter_tree():
	add_to_group(TEAM)
	moveSpeed = 80.0
	initialJumpVel = 50.0

func _process(delta):
	if target == null:
		movement = Common.STAY
	else:
		if target.position.distance_to(position) > NOT_INTERESTED:
			print_debug(name +  ": target lost.")
			target = null
			return

		var targetVisible := _targetVisible()
		if targetVisible and target.position.distance_to(position) > SOCIAL_DISTANCE:
			if target.position.x > position.x:
				movement = Common.RIGHT
			if target.position.x < position.x:
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

func _targetVisible() -> bool:
	if target != null:
		var spaceState := get_world_2d().direct_space_state
		var intersectRes := spaceState.intersect_ray(position, target.position, [self], collision_mask)
		return intersectRes and intersectRes.collider == target
	else:
		return false

func _on_DetectionArea_body_entered(body: Node2D):
	if body.is_in_group(Player.TEAM):
		target = body
