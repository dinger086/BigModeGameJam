extends Area2D

class_name HurtBoxComponent

signal attack_damaged

@export var animation_player: AnimationPlayer

@export var damage = 1
@export var knockback = 1
@export var attack_speed = 1
enum AttackType { 
	PLAYER,
	ENEMY
}
@export var attack_type: AttackType = AttackType.ENEMY

func _init() -> void:
	pass


func _ready() -> void:
	collision_mask = 0
	if attack_type == AttackType.PLAYER:
		print("HurtBoxComponent: Player attack")
		collision_layer = 4
	elif attack_type == AttackType.ENEMY:
		print("HurtBoxComponent: Enemy attack")
		collision_layer = 2
	else:
		print("HurtBoxComponent: Invalid attack type")
		collision_layer = 0

	$CollisionShape2D.disabled = true
	if animation_player == null and get_parent().has_node("AnimationPlayer"):
		animation_player = get_parent().get_node("AnimationPlayer")
		animation_player.connect("animation_finished", on_animation_finished)


func attack() -> void:
	$CollisionShape2D.disabled = false
	animation_player.play("Slash", -1, attack_speed)
	
func on_animation_finished(animation_name: String) -> void:
	#print("Animation finished: " + animation_name)
	$CollisionShape2D.disabled = true

func hit() -> void:
	emit_signal("attack_damaged")
	
