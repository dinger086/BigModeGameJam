extends Area2D

class_name HitBoxComponent

signal damage(damage: int)

enum  HitBoxOwner {PLAYER, ENEMY}

@export var health: HealthComponent
@export var hitbox_owner: HitBoxOwner = HitBoxOwner.ENEMY

@onready var timer = $Timer

var invicible = false 

signal invincibility_started
signal invincibility_ended


func _ready() -> void:
	collision_layer = 0
	self.monitoring = true
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

	self.connect("area_entered", _on_area_entered)

func _on_area_entered(area: HurtBoxComponent) -> void:
	print(area)
	area.hit()
	health.take_damage(area.damage)
	emit_signal("damage", area.damage)
	start_invincibility(1)

func set_invicible(value):
	invicible = value
	if(invicible == true):
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
