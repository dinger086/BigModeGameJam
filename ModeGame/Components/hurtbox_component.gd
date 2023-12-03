extends Area2D

class_name HurtBoxComponent

signal damage(damage: int)

enum HurtBoxOwner {PLAYER, ENEMY}

@export var health: HealthComponent
@export var hurtbox_owner: HurtBoxOwner = HurtBoxOwner.ENEMY

@onready var timer = null

var invicible = false 

signal invincibility_started
signal invincibility_ended


func _ready() -> void:
	if hurtbox_owner == HurtBoxOwner.PLAYER:
		timer = $Timer
	collision_layer = 0
	self.monitoring = true
	if hurtbox_owner == HurtBoxOwner.PLAYER:
		collision_mask = 2
	elif hurtbox_owner == HurtBoxOwner.ENEMY:
		collision_mask = 4
	else:
		print("AttackComponent: Invalid attack type")
		collision_mask = 0
	print("HurtBoxComponent: collision_mask: ", collision_mask)

	self.connect("area_entered", _on_area_entered)

func _on_area_entered(area: HitBoxComponent) -> void:
	
	print(area)
	area.hit()
	health.take_damage(area.damage)
	emit_signal("damage", area.damage)
	print(hurtbox_owner)
	if hurtbox_owner == HurtBoxOwner.PLAYER:
		start_invincibility(10)

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
