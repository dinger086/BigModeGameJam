extends CharacterBody2D

# Slash scene
@onready var slashScene = $PlayerSlash

const SPEED = 400.0
const JUMP_VELOCITY = -750.0
const SELF_KNOCKBACK_AMOUNT = 650.0

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var animation: String

var reset_position: Vector2
var in_cutscene: bool

var abilities: Array[StringName]
var double_jump: bool
var prev_on_floor: bool

var most_recent_direction: Vector2
var knockback_direction: Vector2

enum Modes {
	Life,
	Death,
}

var mode: Modes = Modes.Life


func _ready() -> void:
	on_enter()
	var attack_comp = slashScene.get_node("HurtBoxComponent")
	attack_comp.connect("attack_damaged", self_knockback)
	$"../UI/HealthBar".max_value = $HealthComponent.max_health
	$"../UI/HealthBar".value = $HealthComponent.max_health
	var health = get_node("HealthComponent")
	health.connect("health_changed", _on_health_changed)
	
func _on_health_changed(new_value):
	$"../UI/HealthBar".value = new_value


func _physics_process(delta: float) -> void:
	if in_cutscene:
		return
	
	if not is_on_floor():
		velocity.y += gravity * delta
	elif not prev_on_floor and &"double_jump" in abilities:
		# Some simple double jump implementation.
		double_jump = true

	move()

	prev_on_floor = is_on_floor()
	move_and_slide()

	var new_animation = &"Idle"
	if velocity.y < 0:
		new_animation = &"Jump"
	elif velocity.y >= 0 and not is_on_floor():
		new_animation = &"Fall"
	elif absf(velocity.x) > 1:
		new_animation = &"Run"
	
	if new_animation != animation:
		animation = new_animation
		$AnimationPlayer.play(new_animation)

	if velocity.x > 1:
		$Sprite2D.flip_h = false
	elif velocity.x < -1:
		$Sprite2D.flip_h = true

	
func _input(event: InputEvent) -> void:
	if in_cutscene:
		return

	if event.is_action_pressed("jump"):
		jump()
	if event.is_action_pressed("slash"):
		slash()
	if event.is_action_pressed("dash"):
		dash()


	most_recent_direction = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		most_recent_direction.x = -1
	if Input.is_action_pressed("move_right"):
		most_recent_direction.x = 1
	if Input.is_action_pressed("move_up"):
		most_recent_direction.y = -1
	elif Input.is_action_pressed("move_down"):
		most_recent_direction.y = 1


func on_enter():
	# Position for kill system. Assigned when entering new room (see Game.gd).
	reset_position = position

func jump():
	if is_on_floor() or double_jump:
		if not is_on_floor():
			double_jump = false
		velocity.y = JUMP_VELOCITY

	if is_on_wall():
		velocity.y = JUMP_VELOCITY
		if $Sprite2D.flip_h:
			velocity.x = -JUMP_VELOCITY
		else:
			velocity.x = JUMP_VELOCITY


func move():
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = move_toward(velocity.x, direction * SPEED, SPEED*.2)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED*.1)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED*.1)


func slash():
	most_recent_direction = most_recent_direction.normalized()
	if most_recent_direction == Vector2.ZERO:
		if $Sprite2D.flip_h:
			most_recent_direction.x = -1
		else:
			most_recent_direction.x = 1
	
	knockback_direction = -most_recent_direction
	slashScene.position = most_recent_direction * 64
	var angle = most_recent_direction.angle_to(Vector2.RIGHT) * 3 * 5
	slashScene.rotation = angle
	var attack = slashScene.get_node("HurtBoxComponent")
	attack.attack()


func dash():
	if most_recent_direction == Vector2.ZERO:
		if $Sprite2D.flip_h:
			most_recent_direction.x = -1
		else:
			most_recent_direction.x = 1
	
	velocity += most_recent_direction * SPEED * 5


func self_knockback():
	if !is_on_floor():
		velocity = knockback_direction * SELF_KNOCKBACK_AMOUNT


func ignore_input(time: float) -> void:
	in_cutscene = true
	await get_tree().create_timer(time).timeout
	in_cutscene = false
