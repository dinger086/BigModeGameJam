extends CharacterBody2D



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	set_collision_mask_value(1, true)
	set_collision_layer_value(1, false)
	set_collision_layer_value(3, true)

	var health = get_node("healthComponent")
	health.connect("died", _on_death)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()

func _on_death():
	queue_free()
