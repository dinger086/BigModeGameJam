extends CharacterBody2D
class_name EnemyBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var deathEffectScene = preload("res://ModeGame/Objects/death_effect.tscn")

@onready var sprite = $Sprite
@onready var blinkAnimationPlayer = $BlinkAnimationPlayer
@onready var timer = $Timer
@onready var hurtBox = $HurtBoxComponent

func _ready():
	set_collision_mask_value(1, true)
	set_collision_layer_value(1, false)
	set_collision_layer_value(3, true)

	var health = get_node("HealthComponent")
	health.connect("died", _on_death)
	var hurtbox = get_node("HurtBoxComponent")
	hurtbox.connect("damage", _on_hit)
	
	blinkAnimationPlayer.play("stop")

func _on_hit(_damage, knockback, hit_location):
	var knockback_vec = Vector2()
	if hit_location.x - self.position.x > 0:
		knockback_vec.x = -knockback
	else:
		knockback_vec.x = knockback
	knockback_vec.y = knockback
	velocity = knockback_vec * 5
	
	
	#hurtBox.set_deferred("monitoring", false) 
	blinkAnimationPlayer.play("start")
	timer.start(0.5)
	await timer.timeout
	blinkAnimationPlayer.play("stop")
	#hurtBox.set_deferred("monitoring", true) 

	

func _process(_delta):
	pass

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		#friction
		velocity.x = move_toward(velocity.x, 0, delta*1500)
	move_and_slide()

func _on_death():
	self.visible = false
	set_collision_mask_value(1, false)
	var deathEffect = deathEffectScene.instantiate()
	deathEffect.global_position = self.global_position
	self.get_parent().add_child(deathEffect)
	await deathEffect.animation_finished
	self.get_parent().remove_child(deathEffect)
	deathEffect.queue_free()
	queue_free()
