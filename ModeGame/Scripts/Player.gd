extends CharacterBody2D

# Slash scene
@onready var slashScene = $PlayerSlash

const SPEED = 400.0
const JUMP_VELOCITY = -750.0
const SELF_KNOCKBACK_AMOUNT = 650.0


var speed: float = SPEED
var jump_velocity: float = JUMP_VELOCITY
var knockback_speed: float = SELF_KNOCKBACK_AMOUNT
var wall_gravity_scale: float = 0.5


var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var reset_position: Vector2

var abilities: Array[StringName]
var double_jump: bool

var most_recent_direction: Vector2
var knockback_direction: Vector2


@onready var health = get_node("HealthComponent")

@onready var blinkAnimationPlayer = $BlinkAnimationPlayer

@onready var healthBar = $"../UI/HealthBar"

@onready var interaction = get_node("InteractionPlayer")

func _ready() -> void:
	on_enter()
	
	healthBar.max_value = $HealthComponent.max_health
	healthBar.value = $HealthComponent.max_health
	health.connect("health_changed", _on_health_changed)
	blinkAnimationPlayer.play("Stop")
	
func _on_health_changed(new_value):
	healthBar.value = new_value


func _physics_process(_delta: float) -> void:
	move_and_slide()
	if velocity.x > 1:
		$Sprite2D.flip_h = false
	elif velocity.x < -1:
		$Sprite2D.flip_h = true


func on_enter():
	# Position for kill system. Assigned when entering new room (see Game.gd).
	reset_position = position

func play(animation: String) -> void:
	$AnimationPlayer.play(animation)