extends State
class_name Fall


func enter():
	player.play("Fall")

func process(delta):
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			player.velocity.x = move_toward(player.velocity.x, direction * player.speed, player.speed*.2)
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, player.speed*.1)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.speed*.1)

func physics_process(delta):
	if player.is_on_floor():
		player.double_jump = true
		transitioned.emit(self, "Idle")
	player.velocity.y += player.gravity * delta

	if Input.is_action_just_pressed("jump") and player.double_jump:
		transitioned.emit(self, "Jump")
		player.double_jump = false

	if Input.is_action_just_pressed("slash"):
		transitioned.emit(self, "Attack")

