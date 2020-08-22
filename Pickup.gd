extends Area2D

class_name Pickup

export(Common.PickupType) var type

func _ready():
	$Icon/Health.visible        = type == Common.PickupType.HEALTH
	$Icon/Shotgun.visible       = type == Common.PickupType.SHOTGUN
	$Icon/SubmachineGun.visible = type == Common.PickupType.SUBMACHINE_GUN
	
	$AnimationPlayer.play("Idle")

func _take():
	$AnimationPlayer.play("Take")

func _on_Pickup_body_entered(body):
	if body is Player:
		if type == Common.PickupType.HEALTH:
			if body.heal(25):
				_take()
		elif type == Common.PickupType.SHOTGUN:
			if body.addWeapon(Weapon.WeaponType.SHOTGUN):
				_take()
		elif type == Common.PickupType.SUBMACHINE_GUN:
			if body.addWeapon(Weapon.WeaponType.SUBMACHINE_GUN):
				_take()
