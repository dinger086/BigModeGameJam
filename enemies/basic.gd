
extends EnemyBody2D

@onready var slash_scene = $EnemySlash
var speed = 100
var attack_range = 50

var active = false
var player = null


func _ready():
	super._ready()
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


func _process(_delta):
	if !active:
		velocity.x = 0
		return
	move_to(player.global_position)

	var distance = global_position.distance_to(player.global_position)
	
	if distance < attack_range:
		attack(player.global_position)



func move_to(target: Vector2):
	var direction = target - global_position
	direction = direction.normalized()
	velocity.x = move_toward(velocity.x, direction.x * speed, 50)


func attack(target: Vector2):
	
	var direction = target - global_position

	direction = direction.normalized()
	
	slash_scene.position = direction * 64
	var angle = direction.angle_to(Vector2.RIGHT) * 3 * 5
	slash_scene.rotation = angle
	
	var attack_component = slash_scene.get_node("HitBoxComponent")
	attack_component.attack()
