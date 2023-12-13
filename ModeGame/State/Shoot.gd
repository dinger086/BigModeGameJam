extends State
class_name Shoot

func enter():
	if player.mode:
		# Death mode
		player.grapple_hook = player.bulletSpawner.spawn_grapple_hook(get_direction())
		player.grapple_hook.connect("attached", on_grapple_hook_attach)
		player.grapple_hook.connect("hit_enemy", on_hit_enemy)
	else:
		# Life mode
		player.bulletSpawner.spawn_bullet(get_direction())

func process(delta):
	pass
	

func physics_process(delta):
	if player.is_on_floor():
		player.double_jump = true
		transitioned.emit(self, "Idle")
	elif player.is_on_wall():
			transitioned.emit(self, "Wall")
	player.velocity.y += player.gravity * delta

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

func on_grapple_hook_attach():
	player.is_hooked = true
	player.grapple_velocity = player.velocity
	transitioned.emit(self, "Fall")

func on_hit_enemy(body):
	var enemy = body.get_parent()
	enemy.is_hooked = true
	enemy.hooked_to = player
