extends Area2D

class_name AttackComponent

signal attack_damaged

@export var animation_player: AnimationPlayer

@export var damage = 1
@export var knockback = 1
@export var attack_speed = 1

func _init() -> void:
	collision_layer = 2
	collision_mask = 0

func _ready():
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
	