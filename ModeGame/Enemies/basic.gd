
extends CharacterBody2D

@onready var slash_scene = $EnemySlash
var speed = 50
var attack_range = 50
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var active = false
var player = null


func _ready():
	var health = get_node("HealthComponent")
	health.connect("died", _on_death)
	var sight = get_node("Sight")
	sight.connect("sighted", activate)
	sight.connect("lost_sight", deactivate)

func activate(body):
	print("Activated")
	active = true
	player = body

func deactivate():
	print("Deactivated")
	active = false
	player = null


func _process(delta):
	if !active:
		velocity.x = 0
		return

	move_to(player.global_position)

	var distance = global_position.distance_to(player.global_position)
	
	if distance < attack_range:
		attack(player.global_position)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()

func _on_death():
	queue_free()

func move_to(target: Vector2):
	var direction = target - global_position

	direction = direction.normalized()
	velocity.x = direction.x * speed


func attack(target: Vector2):
	
	var direction = target - global_position

	direction = direction.normalized()
	
	slash_scene.position = direction * 64
	var angle = direction.angle_to(Vector2.RIGHT) * 3 * 5
	slash_scene.rotation = angle
	
	var attack_component = slash_scene.get_node("HitBoxComponent")
	attack_component.attack()
