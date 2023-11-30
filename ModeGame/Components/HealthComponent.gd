extends Node2D

class_name HealthComponent
signal health_changed(health)
signal died()

@export var max_health: int
var health: int

func _ready():
	health = max_health

func take_damage(damage):
	health -= damage
	print("Health: ", health)
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("died")

func heal(amount):
	health += amount
	if health > max_health:
		health = max_health
	emit_signal("health_changed", health)

func set_max_health(amount):
	max_health = amount
	if health > max_health:
		health = max_health
	emit_signal("health_changed", health)

