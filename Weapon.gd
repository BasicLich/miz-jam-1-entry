extends Node2D

class_name Weapon

var projectileClass := preload("res://Projectile.tscn")

export var fireInterval := 1.0
var fireIntervalCounter := 0.0

var aim = Common.STRAIGHT setget set_aim, get_aim
var dir = Common.LEFT setget set_dir, get_dir

func _ready():
	set_process(true)

func set_aim(aAim):
	aim = aAim
	_updateWeapon()
	
func get_aim():
	return aim

func set_dir(aDir):
	dir = aDir
	_updateWeapon()

func get_dir():
	return dir

func _process(delta):
	fireIntervalCounter = fireIntervalCounter + delta
	if fireIntervalCounter >= fireInterval:
		fireIntervalCounter = fireInterval

func _updateWeapon():
	if aim == Common.STRAIGHT:
		rotation_degrees = 0
		if dir == Common.LEFT:
			scale.x = -1
		elif dir == Common.RIGHT:
			scale.x = 1
	elif aim == Common.UP:
		if dir == Common.LEFT:
			rotation_degrees = -270
			scale.x = -1
		elif dir == Common.RIGHT:
			rotation_degrees = -90
			scale.x = 1
	elif aim == Common.DOWN:
		if dir == Common.LEFT:
			rotation_degrees = -90
			scale.x = -1
		elif dir == Common.RIGHT:
			rotation_degrees = 90
			scale.x = 1

func shoot():
	if fireIntervalCounter == fireInterval:
		fireIntervalCounter = 0.0
		var projectile := projectileClass.instance() as Projectile
		var pp := $ProjectilePos as Node2D
		
		projectile.transform = pp.get_global_transform()
		
		get_tree().root.add_child(projectile)

		#print_debug("Bang!")
