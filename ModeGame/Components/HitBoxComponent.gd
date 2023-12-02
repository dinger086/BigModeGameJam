extends Area2D

class_name HitBoxComponent

signal damage(damage: int)

enum  HitBoxOwner {PLAYER, ENEMY}

@export var health: HealthComponent
@export var hitbox_owner: HitBoxOwner = HitBoxOwner.ENEMY


func _ready() -> void:
	collision_layer = 0
	if hitbox_owner == HitBoxOwner.PLAYER:
		print("HitBoxComponent: Player hitbox")
		collision_mask = 2
	elif hitbox_owner == HitBoxOwner.ENEMY:
		print("HitBoxComponent: Enemy hitbox")
		collision_mask = 4
	else:
		print("AttackComponent: Invalid attack type")
		collision_mask = 0
	print("HitBoxComponent: collision_mask: ", collision_mask)

	monitoring = true
	self.connect("area_entered", _on_area_entered)

func _on_area_entered(area: HurtBoxComponent) -> void:
	print(area)
	area.hit()
	health.take_damage(area.damage)
	emit_signal("damage", area.damage)




