
extends CharacterBody2D

@onready var bullet_spawner = $BulletSpawner
var speed = 50
var attack_range = 1000
var attack_speed_time = 1.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var active = false
var player = null
@onready var start_time := Time.get_ticks_msec()



func _ready():
	var health = get_node("HealthComponent")
	health.connect("died", _on_death)
	var sight = get_node("Sight")
	sight.connect("sighted", activate)
	sight.connect("lost_sight", deactivate)

func activate(body):
	active = true
	player = body

func deactivate():
	active = false
	player = null


func _process(delta):
	if !active:
		velocity.x = 0
		return

	move_to(player.global_position)

	var distance = global_position.distance_to(player.global_position)
	
	if distance < attack_range:
		if Time.get_ticks_msec() - start_time > attack_speed_time * 1000:
			print("Shoot")
			start_time = Time.get_ticks_msec()
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
	
	bullet_spawner.spawn_bullet(direction)
