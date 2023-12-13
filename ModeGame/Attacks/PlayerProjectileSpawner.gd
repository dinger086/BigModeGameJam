extends Node2D

@export var bullet: PackedScene
@export var grapple_hook: PackedScene
@export var bullet_spawn_time: float = 15.0

func spawn_bullet(direction: Vector2):
	var bullet_instance: Node2D = bullet.instantiate()
	bullet_instance.set_position(get_global_position())
	get_tree().get_root().get_node("Game").add_child(bullet_instance)
	var bullet_component = bullet_instance.get_node("BulletComponent")

	bullet_component.set_direction(direction)

func spawn_grapple_hook(direction: Vector2) -> Node2D:
	var grapple_hook_instance: Node2D = grapple_hook.instantiate()
	grapple_hook_instance.set_position(get_global_position())
	grapple_hook_instance.set_source(get_node(".."))
	get_tree().get_root().get_node("Game").add_child(grapple_hook_instance)

	grapple_hook_instance.set_direction(direction)

	return grapple_hook_instance