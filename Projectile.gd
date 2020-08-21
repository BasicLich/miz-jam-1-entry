extends KinematicBody2D

class_name Projectile

var sparkClass = preload("res://Spark.tscn")
var team: String

const SPEED := 12.0
var damage = 1

func _ready():
	set_physics_process(true)
	
func _physics_process(delta):
	var dir := Vector2(cos(rotation), sin(rotation))
	var col := move_and_collide(dir * SPEED)
	if col != null:
		var needToDestroy = false
		if col.collider.has_method("takeDamage"):
			col.collider.takeDamage(damage)
			needToDestroy = true
		if col.collider is TileMap:
			needToDestroy = true
		
		if not col.collider.is_in_group(team):
			needToDestroy = true
			
		if col.collider is Switch:
			needToDestroy = true
			col.collider.toggle()
		
		if needToDestroy:
			var s := sparkClass.instance() as Sprite
			s.position = col.position
			get_tree().root.add_child(s)
			queue_free()
