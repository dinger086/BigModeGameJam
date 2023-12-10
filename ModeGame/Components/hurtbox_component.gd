extends Area2D

class_name HurtBoxComponent

signal damage(damage: int, knockback: int, attack_location: Vector2)

enum HurtBoxOwner {PLAYER, ENEMY}

@export var health: HealthComponent
@export var hurtbox_owner: HurtBoxOwner = HurtBoxOwner.ENEMY
@export var touch_damage: int = 1

@onready var timer = null

var invicible = false 

signal invincibility_started
signal invincibility_ended


func _ready() -> void:
	set_collision_mask_value(1, false)
	set_collision_layer_value(1, false)
	self.monitoring = true
	if hurtbox_owner == HurtBoxOwner.PLAYER:
		set_collision(true)
		timer = $Timer
	elif hurtbox_owner == HurtBoxOwner.ENEMY:
		set_collision_mask_value(3, true)
		set_collision_layer_value(2, true)
	else:
		print("AttackComponent: Invalid attack type")
		collision_mask = 0
	print("HurtBoxComponent: collision_mask: ", collision_mask)

	self.connect("area_entered", _on_area_entered)

func _on_area_entered(area:Node2D) -> void:
	if HurtBoxOwner.ENEMY == hurtbox_owner:
		print("Player hit enemy")
	if area is HitBoxComponent and not invicible:
		area.hit(self)
		print(area)
		health.take_damage(area.damage)
		emit_signal("damage", area.damage, area.knockback, area.global_position)
		print(hurtbox_owner)
		if hurtbox_owner == HurtBoxOwner.PLAYER:
			start_invincibility(timer.wait_time)
	elif area is HurtBoxComponent and hurtbox_owner == HurtBoxOwner.PLAYER:
		health.take_damage(area.touch_damage)
		emit_signal("damage", area.touch_damage, 0, area.global_position)
		start_invincibility(timer.wait_time)


func set_invicible(value: bool):
	invicible = value
	if(invicible):
		emit_signal("invincibility_started")
		set_deferred("monitoring", false) 
	else:
		emit_signal("invincibility_ended")
		set_deferred("monitoring", true) 


func start_invincibility(duration):
	set_invicible(true)
	timer.start(duration)

func _on_timer_timeout():
	set_invicible(false)

func set_collision(value: bool):
	set_collision_mask_value(2, value)
