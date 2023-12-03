extends State
class_name Walk

func enter():
	player.play("Run")

func process(delta):
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			player.velocity.x = move_toward(player.velocity.x, direction * player.speed, player.speed*.2)
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, player.speed*.1)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.speed*.1)

	if Input.is_action_just_pressed("jump"):
		transitioned.emit(self, "Jump")
	elif Input.is_action_just_pressed("slash"):
		transitioned.emit(self, "Attack")

	if not player.is_on_floor():
		transitioned.emit(self, "Fall")
		
	if player.velocity == Vector2.ZERO:
		transitioned.emit(self, "Idle")