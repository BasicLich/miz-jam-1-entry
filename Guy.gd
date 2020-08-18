extends Actor

class_name Guy

const TEAM := "Guy"
const TEAM_PROJECTILE := TEAM + "Projectile"
const SOCIAL_DISTANCE := 60.0

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
		if _targetVisible() and target.position.distance_to(position) > SOCIAL_DISTANCE:
			if target.position.x > position.x:
				movement = Common.RIGHT
			if target.position.x < position.x:
				movement = Common.LEFT
		else:
			movement = Common.STAY

	if rnd.randf_range(0, 200) < 50:
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

func _on_DetectionArea_body_exited(body):
	if body.is_in_group(Player.TEAM):
		target = null
