extends CharacterBody2D

# Slash scene
@onready var slashScene = $PlayerSlash


@export var speed: float = 400.0
@export var jump_velocity: float = -750.0
@export var knockback_speed: float = 650.0
@export var wall_gravity_scale: float = 0.5
@export var coyote_time: float = 100 # ms

var jumped = false

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var reset_position: Vector2

var abilities: Array[StringName]
var double_jump: bool

var most_recent_direction: Vector2
var knockback_direction: Vector2

enum Mode{
	LIFE,
	DEATH
}
var mode = Mode.LIFE

@onready var health = get_node("HealthComponent")

@onready var blinkAnimationPlayer = $BlinkAnimationPlayer

@onready var healthBar = $"../UI/HealthBar"

@onready var interaction = get_node("InteractionPlayer")

@onready var animationPlayer = get_node("AnimationPlayer")

func _ready() -> void:

	set_collision_layer_value(2, true)
	set_collision_layer_value(1, false)

	on_enter()
	
	healthBar.max_value = $HealthComponent.max_health
	healthBar.value = $HealthComponent.max_health
	health.connect("health_changed", _on_health_changed)
	blinkAnimationPlayer.play("Stop")
	
	$AudioStreamPlayer2D.play()
	
	
func _on_health_changed(new_value):
	healthBar.value = new_value


func _physics_process(_delta: float) -> void:
	move_and_slide()
	if velocity.x > 1:
		$Sprite2D.flip_h = false
	elif velocity.x < -1:
		$Sprite2D.flip_h = true

	var wings = $Sprite2D.get_node("WingDash")
	if $Sprite2D.flip_h:
		wings.flip_h = true
		wings.position.x = abs(wings.position.x)
	else:
		wings.flip_h = false
		wings.position.x = -abs(wings.position.x)
	



func on_enter():
	# Position for kill system. Assigned when entering new room (see Game.gd).
	reset_position = position

func play(animation: String) -> void:
	$AnimationPlayer.play(animation)

func switch_mode():
	if mode == Mode.DEATH:
		mode = Mode.LIFE
		blinkAnimationPlayer.play("Life")
	else:
		mode = Mode.DEATH
		blinkAnimationPlayer.play("Death")
	print("Switched to mode: ", "death" if mode == Mode.DEATH else "life")
	
