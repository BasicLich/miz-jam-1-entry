extends KinematicBody2D

class_name Projectile

var sparkClass = preload("res://Spark.tscn")

const SPEED := 15.0
const DAMAGE := 2

func _ready():
	set_physics_process(true)
	
func _physics_process(delta):
	var dir := Vector2(cos(rotation), sin(rotation))
	var col := move_and_collide(dir * SPEED)
	if col != null:
		if col.collider.has_method("takeDamage"):
			col.collider.takeDamage(DAMAGE)
		#print_debug("Collider: " + var2str(col.collider))
		var s := sparkClass.instance() as Sprite
		s.position = col.position
		get_tree().root.add_child(s)
		queue_free()
