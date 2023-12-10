extends CharacterBody2D

@export var speed: float = 400.0
@export var jump_velocity: float = -750.0
@export var knockback_speed: float = 650.0
@export var wall_gravity_scale: float = 0.5
@export var coyote_time: float = 0.1
@export var dash_speed: float = 1000.0
@export var debug: bool = true
@export var damage_knockback: Vector2 = Vector2(1250, -500)


var time_since_floor: float = 0.0
var jumped = false
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var reset_position: Vector2
var abilities: Array[StringName]
var ability_cooldowns: Dictionary
var double_jump: bool
var attack_location = Vector2.ZERO
var damaged = false

enum Facing{
	LEFT,
	RIGHT
}
var facing = Facing.RIGHT
enum Mode{
	LIFE,
	DEATH
}
var mode = Mode.DEATH


@onready var health = get_node("HealthComponent")
@onready var hurtbox = get_node("HurtBoxComponent")
@onready var blinkAnimationPlayer = $BlinkAnimationPlayer
@onready var healthBar = $"../UI/HealthBar"
@onready var interaction = get_node("InteractionPlayer")
@onready var animationPlayer = get_node("AnimationPlayer")
@onready var shield = get_node("Sprite2D/ShieldBash")
@onready var slashScene = $PlayerSlash


func _ready() -> void:
	if debug:
		abilities = ["dash", "double_jump", "wall_jump"]
	set_collision_layer_value(2, true)
	set_collision_layer_value(1, false)

	on_enter()
	
	healthBar.max_value = $HealthComponent.max_health
	healthBar.value = $HealthComponent.max_health
	health.connect("health_changed", _on_health_changed)
	hurtbox.connect("damage", _on_damage_taken)
	blinkAnimationPlayer.play("Stop")
	
	$AudioStreamPlayer2D.play()
	
func _on_damage_taken(_damage: int, _knockback: int, attack_loc: Vector2) -> void:
	damaged = true
	attack_location = attack_loc

func _on_health_changed(new_value):
	healthBar.value = new_value


func _physics_process(delta: float) -> void:
	if is_on_floor():
		time_since_floor = 0.0
	else:
		time_since_floor += delta
	move_and_slide()


func _input(event):
	if event.is_action_pressed("move_left"):
		flip(true)
	if event.is_action_pressed("move_right"):
		flip(false)
	

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
	
func flip(is_flipped : bool) -> void:
	facing = Facing.LEFT if is_flipped else Facing.RIGHT
	$Sprite2D.flip_h = is_flipped
	for child in $Sprite2D.get_children():
		if child is Sprite2D:
			child.position.x = abs(child.position.x) if is_flipped else -abs(child.position.x)
			child.flip_h = is_flipped
		elif child is Node2D:
			child.position.x = -abs(child.position.x) if is_flipped else abs(child.position.x)
			var child_sprite = child.get_node("Shield")
			if child_sprite != null:
				child_sprite.flip_h = is_flipped
		