extends Node2D

class_name Weapon

const SHOTGUN_SPREAD = 15
const SHOTGUN_DAMAGE = 32
const GUN_DAMAGE = 14
const SUBMACHINE_GUN_DAMAGE = 8

enum WeaponType {GUN, SHOTGUN, SUBMACHINE_GUN}

var projectileClass := preload("res://Projectile.tscn")

export var type := WeaponType.GUN
var fireIntervalCounter := 0.0

var intervals := {
	WeaponType.GUN: 0.2,
	WeaponType.SHOTGUN: 0.8,
	WeaponType.SUBMACHINE_GUN: 0.05
}

var aim = Common.STRAIGHT setget set_aim, get_aim
var dir = Common.LEFT setget set_dir, get_dir

var rnd := RandomNumberGenerator.new()

func _ready():
	set_process(true)

func _enter_tree():
	rnd.randomize()
	switchWeapon(type)

func switchWeapon(aType):
	type = aType
	$GunSprite.visible        = aType == WeaponType.GUN
	$ShotgunSprite.visible    = aType == WeaponType.SHOTGUN
	$SubmachineSprite.visible = aType == WeaponType.SUBMACHINE_GUN

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
	var fireInterval := intervals[type] as float
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

func shoot(team: String):
	var fireInterval := intervals[type] as float
	if fireIntervalCounter == fireInterval:
		fireIntervalCounter = 0.0
		if type == WeaponType.GUN or type == WeaponType.SUBMACHINE_GUN:
			var spread := 0.0
			if type == WeaponType.GUN:
				spread = rnd.randf_range(-2, 2)
				$PistolSound.play()
			elif type == WeaponType.SUBMACHINE_GUN:
				spread = rnd.randf_range(-7, 7)
				$SMGSound.play()
			var projectile := projectileClass.instance() as Projectile
			projectile.team = team
			if type == WeaponType.GUN:
				projectile.damage = GUN_DAMAGE
			else:
				projectile.damage = SUBMACHINE_GUN_DAMAGE
			var pp := $ProjectilePos as Node2D
			projectile.transform = pp.get_global_transform()
			projectile.rotation_degrees += spread
			projectile.add_to_group(team)
			get_tree().root.add_child(projectile)
			
		elif type == WeaponType.SHOTGUN:
			$ShotgunSound.play()
			for i in range(1, 5):
				var spread := rnd.randf_range(-SHOTGUN_SPREAD, SHOTGUN_SPREAD)
				var projectile := projectileClass.instance() as Projectile
				projectile.team = team
				projectile.damage = SHOTGUN_DAMAGE
				var pp := $ProjectilePos as Node2D
				projectile.transform = pp.get_global_transform()
				projectile.rotation_degrees += spread
				projectile.add_to_group(team)
				get_tree().root.add_child(projectile)

		#print_debug("Bang!")
