extends Node2D

class_name BulletComponent

@export var speed = 20000
@export var life_time = 1
enum BulletType {
	SIMPLE,
	LOB
}
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var type = BulletType.SIMPLE
@export var hitbox: HitBoxComponent

@onready var start_time := Time.get_ticks_msec()

var bullet: CharacterBody2D

var direction = Vector2(-1, 0)


func _ready():
	hitbox.enable()
	bullet = get_parent()
	hitbox.connect("attack_damaged", on_hit)
	hitbox.connect("hit_physics_body", on_wall_hit)


func on_hit(_body) -> void:
	bullet.queue_free()

func on_wall_hit() -> void:
	bullet.queue_free()


func _process(delta):
	if Time.get_ticks_msec() - start_time > life_time * 1000:
		bullet.queue_free()
		print("bullet died")


func _physics_process(delta: float) -> void:
	if type == BulletType.SIMPLE:
		bullet.velocity = direction * speed * delta
	elif type == BulletType.LOB:
		bullet.velocity = direction * speed * delta
		bullet.velocity.y += gravity * delta
	else:
		pass
	
	bullet.move_and_slide()


func set_direction(dir: Vector2):
	direction = dir
