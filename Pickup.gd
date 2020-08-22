extends Area2D

class_name Pickup

export(Common.PickupType) var type

func _ready():
	$Icon/Health.visible        = type == Common.PickupType.HEALTH
	$Icon/Shotgun.visible       = type == Common.PickupType.SHOTGUN
	$Icon/SubmachineGun.visible = type == Common.PickupType.SUBMACHINE_GUN
	
	$AnimationPlayer.play("Idle")

func _on_Pickup_body_entered(body):
	if body is Player:
		if type == Common.PickupType.HEALTH:
			if body.heal(25):
				queue_free()
		elif type == Common.PickupType.SHOTGUN:
			if body.addWeapon(Weapon.WeaponType.SHOTGUN):
				queue_free()
		elif type == Common.PickupType.SUBMACHINE_GUN:
			if body.addWeapon(Weapon.WeaponType.SUBMACHINE_GUN):
				queue_free()
