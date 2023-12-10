
extends EnemyBody2D

@onready var bullet_spawner = $BulletSpawner
var speed = 100
var attack_range = 1000
var attack_speed_time = 1.0

var active = false
var player = null
@onready var start_time := Time.get_ticks_msec()


func _ready():
	super._ready()
	var sight = get_node("Sight")
	sight.connect("sighted", activate)
	sight.connect("lost_sight", deactivate)

func activate(body):
	active = true
	player = body

func deactivate():
	active = false
	player = null


func _process(_delta):
	if !active:
		velocity.x = 0
		return

	move_to(player.global_position)

	var distance = global_position.distance_to(player.global_position)
	
	if distance < attack_range:
		if Time.get_ticks_msec() - start_time > attack_speed_time * 1000:
			start_time = Time.get_ticks_msec()
			attack(player.global_position)


func move_to(target: Vector2):
	var direction = target - global_position
	direction = direction.normalized()
	velocity.x = move_toward(velocity.x, direction.x * speed, 50)


func attack(target: Vector2):
	
	var direction = target - global_position

	direction = direction.normalized()
	
	bullet_spawner.spawn_bullet(direction)
