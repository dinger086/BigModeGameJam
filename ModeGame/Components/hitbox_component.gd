extends Area2D

class_name HitBoxComponent

signal attack_damaged
signal hit_physics_body

@export var animation_player: AnimationPlayer

@export var damage = 1
@export var knockback = 1
@export var attack_speed = 1
enum AttackType { 
	PLAYER,
	ENEMY
}
@export var attack_type: AttackType = AttackType.ENEMY


func _ready() -> void:
	collision_mask = 1
	if attack_type == AttackType.PLAYER:
		collision_layer = 4
	elif attack_type == AttackType.ENEMY:
		collision_layer = 2
	else:
		print("HitBoxComponent: Invalid attack type")
		collision_layer = 0

	self.connect("body_entered", hit_wall)

	$CollisionShape2D.disabled = true
	if animation_player == null and get_parent().has_node("AnimationPlayer"):
		animation_player = get_parent().get_node("AnimationPlayer")
		animation_player.connect("animation_finished", on_animation_finished)

func hit_wall(body: Node) -> void:
	if body is TileMap:
		emit_signal("hit_physics_body")

func attack() -> void:
	$CollisionShape2D.disabled = false
	animation_player.play("Slash", -1, attack_speed)
	
func on_animation_finished(animation_name: String) -> void:
	$CollisionShape2D.disabled = true

func hit() -> void:
	emit_signal("attack_damaged")

func enable() -> void:
	$CollisionShape2D.disabled = false

func disable() -> void:
	$CollisionShape2D.disabled = true
