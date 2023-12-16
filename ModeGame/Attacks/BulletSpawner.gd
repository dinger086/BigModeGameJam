extends Node2D

@export var bullet: PackedScene
@export var bullet_spawn_time: float = 1.0

func spawn_bullet(direction: Vector2):
	var bullet_instance: Node2D = bullet.instantiate()
	bullet_instance.set_position(get_global_position())
	get_tree().get_root().get_node("Game").add_child(bullet_instance)
	var bullet_component = bullet_instance.get_node("BulletComponent")
	bullet_component.set_direction(direction)


