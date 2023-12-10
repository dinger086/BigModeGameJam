extends State
class_name Dash

var hurtbox = null
var shield_hitbox = null
var slash_fury = null
var in_slash = false

func startup():
	player.animationPlayer.connect("animation_finished", on_animation_finished)
	hurtbox = player.get_node("HurtBoxComponent")
	shield_hitbox = player.shield.get_node("HitBoxComponent")
	shield_hitbox.connect("attack_damaged", _on_shield_bash_hit)
	slash_fury = player.get_node("SlashFury")
	slash_fury.get_node("HitBoxComponent").connect("attack_damaged", _on_slash_fury_hit)


func enter():
	if player.abilities.has("dash"):
		player.animationPlayer.play("Dash")
		hurtbox.set_collision(false)
		if player.mode:
			#death mode
			player.velocity = Vector2(player.dash_speed * get_direction().x, player.dash_speed * get_direction().y)
			slash_fury.visible = true
			slash_fury.get_node("HitBoxComponent").enable()
		else:
			#life mode
			player.velocity.x = player.dash_speed * get_horizontal()
			player.shield.visible = true
			shield_hitbox.enable()


func process(_delta):
	if not player.abilities.has("dash") and not in_slash:
		transitioned.emit(self, "Fall")

func on_animation_finished(anim_name):
	if anim_name == "Dash" and not in_slash:
		transitioned.emit(self, "Fall")
		player.shield.visible = false
		hurtbox.set_collision(true)
		shield_hitbox.disable()
		slash_fury.get_node("HitBoxComponent").disable()


func get_horizontal():
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1

	if direction == Vector2.ZERO:
		direction.x = 1 if player.facing else -1
	return direction.normalized().x

func get_direction() -> Vector2:
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1

	if direction == Vector2.ZERO:
		direction.x = 1 if player.facing else -1
	return direction.normalized()

func _on_shield_bash_hit(_body):
	player.velocity = Vector2.ZERO

func _on_slash_fury_hit(body):
	player.get_node("Sprite2D").visible = false
	slash_fury.get_node("HitBoxComponent").disable()
	in_slash = true
	player.velocity = Vector2.ZERO
	player.global_position = body.global_position
	slash_fury.get_node("GPUParticles2D").visible = true
	var timer = Timer.new()
	add_child(timer)
	timer.set_wait_time(0.5)
	timer.set_one_shot(true)
	timer.start()
	timer.connect("timeout", _on_slash_finished)
	var timer2 = Timer.new()
	add_child(timer2)
	timer2.set_wait_time(1)
	timer2.set_one_shot(true)
	timer2.start()
	timer2.connect("timeout", _invinibility_finished)
	

func _on_slash_finished():
	player.get_node("Sprite2D").visible = true
	print("slash finished")
	slash_fury.get_node("GPUParticles2D").visible = false
	in_slash = false
	player.velocity = Vector2(player.damage_knockback.x * get_direction().x, player.damage_knockback.y)
	player.shield.visible = false
	transitioned.emit(self, "Fall")
	#hurtbox.start_invincibility(0.5)

func _invinibility_finished():
	print("invinibility finished")
	hurtbox.set_collision(true)