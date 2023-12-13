extends CharacterBody2D

var source: Node2D

signal attached
signal hit_enemy

@export var speed = 100000
@export var life_time = 1

@onready var start_time := Time.get_ticks_msec()
@onready var hitbox := get_node("HitBoxComponent")

var direction = Vector2(-1, 0)
var in_wall = false
var in_enemy = false
var enemy = null
var length = 0

func _ready():
	hitbox.enable()
	hitbox.connect("attack_damaged", _on_hit)
	hitbox.connect("hit_physics_body", _on_wall_hit)

func _process(_delta):
	if source == null:
		return

	if not Input.is_action_pressed("shoot"):
		queue_free()

	length = position.distance_to(source.global_position)
	var chain = get_node("GrappleHook/GrappleHookChain")

	chain.region_rect = Rect2(Vector2(0, 0), Vector2(9, length))
	$GrappleHook.rotation = position.angle_to_point(source.global_position) - deg_to_rad(90)

	chain.position = Vector2(0, length / 2)



func set_source(source:Node2D):
	self.source = source

func _on_hit(body) -> void:
	#TODO: damage and bring enemy to player
	in_enemy = true
	enemy = body.get_parent()
	hitbox.disable()
	emit_signal("hit_enemy", body)
	

func _on_wall_hit() -> void:
	#TODO swing player to wall
	in_wall = true
	length = position.distance_to(source.global_position)
	emit_signal("attached")


func _physics_process(delta: float) -> void:
	if source.grapple_hook == null:
		queue_free()
		return
	if in_enemy:
		if enemy == null or not enemy.is_hooked:
			queue_free()
			return
		global_position = enemy.global_position
		return
	if in_wall:
		#if length < 100:
		#	queue_free()
		return
	if Time.get_ticks_msec() - start_time > life_time * 1000:
		queue_free()
	velocity = direction * speed * delta
	move_and_slide()


func set_direction(dir: Vector2):
	direction = dir

func get_length() -> float:
	return length
