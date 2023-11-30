extends Area2D

class_name HitBoxComponent

signal damage(damage: int)

@export var health: HealthComponent

func _init() -> void:
	collision_layer = 0
	collision_mask = 2

func _ready() -> void:
	monitoring = true
	self.connect("area_entered", _on_area_entered)
	

func _on_area_entered(area: AttackComponent) -> void:
	print(area)
	area.hit()
	health.take_damage(area.damage)
	emit_signal("damage", area.damage)




