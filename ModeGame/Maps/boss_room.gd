extends Node2D

@onready var health = get_node("Node2D/boss/HealthComponent")

func _ready():
	health.connect("health_changed", _on_health_changed)

func _on_health_changed(new_health):
	if new_health <= 0:
		$Bird.visible = true

func _process(delta):
	pass