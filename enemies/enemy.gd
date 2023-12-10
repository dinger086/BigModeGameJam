extends CharacterBody2D
class_name EnemyBody2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	set_collision_mask_value(1, true)
	set_collision_layer_value(1, false)
	set_collision_layer_value(3, true)

	var health = get_node("HealthComponent")
	health.connect("died", _on_death)
	var hurtbox = get_node("HurtBoxComponent")
	hurtbox.connect("damage", _on_hit)

func _on_hit(_damage, knockback, hit_location):
	var knockback_vec = Vector2()
	if hit_location.x - self.position.x > 0:
		knockback_vec.x = -knockback
	else:
		knockback_vec.x = knockback
	knockback_vec.y = knockback
	velocity = knockback_vec

func _process(_delta):
	pass

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = move_toward(velocity.x, 0, 50)
	move_and_slide()


func _on_death():
	queue_free()
