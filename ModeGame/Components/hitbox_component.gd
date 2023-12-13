extends Area2D

class_name HitBoxComponent

signal attack_damaged(body)
signal hit_physics_body

@export var animation_player: AnimationPlayer

@export var damage = 1
@export var knockback = 2000
@export var attack_speed = 1
enum AttackType { 
	PLAYER,
	ENEMY
}
@export var attack_type: AttackType = AttackType.ENEMY


func _ready() -> void:
	set_collision_layer_value(1, false)
	if attack_type == AttackType.PLAYER:
		set_collision_layer_value(3, true)
	elif attack_type == AttackType.ENEMY:
		set_collision_layer_value(2, true)
	else:
		print("HitBoxComponent: Invalid attack type")

	self.connect("body_entered", hit_wall)

	$CollisionShape2D.set_deferred("disabled", true)
	if animation_player == null and get_parent().has_node("AnimationPlayer"):
		animation_player = get_parent().get_node("AnimationPlayer")
		animation_player.connect("animation_finished", on_animation_finished)

func hit_wall(body: Node) -> void:
	if body is TileMap:
		emit_signal("hit_physics_body")
	  
func attack() -> void:
	$CollisionShape2D.set_deferred("disabled", false)
	animation_player.play("Slash", -1, attack_speed)
	
func on_animation_finished(_animation_name: String) -> void:
	$CollisionShape2D.set_deferred("disabled", true)

func hit(body) -> void:
	emit_signal("attack_damaged", body)

func enable() -> void:
	$CollisionShape2D.set_deferred("disabled", false)

func disable() -> void:
	$CollisionShape2D.set_deferred("disabled", true)

func set_collinsion_type(type: String) -> void:
	if type == "player":
		set_collision_layer_value(3, true)
		set_collision_layer_value(2, false)
	elif type == "enemy":
		set_collision_layer_value(3, false)
		set_collision_layer_value(2, true)
	else:
		print("HitBoxComponent: Invalid collision type")
