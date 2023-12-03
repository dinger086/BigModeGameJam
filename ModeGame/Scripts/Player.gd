extends CharacterBody2D

# Slash scene
@onready var slashScene = $PlayerSlash

const SPEED = 400.0
const JUMP_VELOCITY = -750.0
const SELF_KNOCKBACK_AMOUNT = 650.0


var speed: float = SPEED
var jump_velocity: float = JUMP_VELOCITY
var knockback_speed: float = SELF_KNOCKBACK_AMOUNT

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var animation: String

var reset_position: Vector2

var abilities: Array[StringName]
var double_jump: bool

var most_recent_direction: Vector2
var knockback_direction: Vector2

@onready var health = get_node("HealthComponent")

@onready var blinkAnimationPlayer = $BlinkAnimationPlayer

@onready var healthBar = $"../UI/HealthBar"

@onready var attack_comp = slashScene.get_node("HitBoxComponent")

@onready var interaction = get_node("InteractionPlayer")

func _ready() -> void:
	on_enter()

	attack_comp.connect("attack_damaged", self_knockback)
	healthBar.max_value = $HealthComponent.max_health
	healthBar.value = $HealthComponent.max_health
	health.connect("health_changed", _on_health_changed)
	blinkAnimationPlayer.play("Stop")
	
func _on_health_changed(new_value):
	healthBar.value = new_value


func _physics_process(delta: float) -> void:
	move_and_slide()
	if velocity.x > 1:
		$Sprite2D.flip_h = false
	elif velocity.x < -1:
		$Sprite2D.flip_h = true




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
	attack_comp.attack()


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


func interact():
	if interaction.can_interact and interaction.interactable:
		interaction.interactable.interact()

		
func play(animation: String) -> void:
	$AnimationPlayer.play(animation)