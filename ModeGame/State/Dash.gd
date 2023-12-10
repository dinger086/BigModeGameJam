extends State
class_name Dash

var hurtbox = null
var shield_hitbox = null

func startup():
	player.animationPlayer.connect("animation_finished", on_animation_finished)
	hurtbox = player.get_node("HurtBoxComponent")
	shield_hitbox = player.shield.get_node("HitBoxComponent")
	shield_hitbox.connect("attack_damaged", _on_shield_bash_hit)


func enter():
	if player.abilities.has("dash"):
		player.animationPlayer.play("Dash")
		player.velocity = get_direction() * player.dash_speed
		hurtbox.set_collision(false)
		if player.mode:
			#death mode
			pass
		else:
			#life mode
			player.shield.visible = true
			shield_hitbox.enable()


func process(_delta):
	if not player.abilities.has("dash"):
		transitioned.emit(self, "Fall")

func on_animation_finished(anim_name):
	if anim_name == "Dash":
		transitioned.emit(self, "Fall")
		player.shield.visible = false
		hurtbox.set_collision(true)
		shield_hitbox.disable()


func get_direction() -> Vector2:
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1

	if direction == Vector2.ZERO:
		direction.x = 1 if player.facing else -1
	return direction.normalized()

func _on_shield_bash_hit():
	print("shield bash hit")
	player.velocity = Vector2.ZERO
