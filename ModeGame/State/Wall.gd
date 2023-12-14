extends State
class_name Wall


func enter():
	pass

func process(delta):
	if player.damaged:
		transitioned.emit(self, "Damaged")
		return
	if player.is_on_wall() and player.abilities.has("wall_jump"):
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			var direction := Input.get_axis("move_left", "move_right")
			if direction:
				player.velocity.x = move_toward(player.velocity.x, direction * player.speed, player.speed*.2)
			else:
				player.velocity.x = move_toward(player.velocity.x, 0, player.speed*.1)
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, player.speed*.1)

		player.velocity.y += player.gravity * delta 
	elif player.is_on_floor():
		transitioned.emit(self, "Idle")
	else:
		transitioned.emit(self, "Fall")


func input(event):
	if event.is_action_pressed("jump"):
		player.velocity.y = player.jump_velocity
		if player.get_node("Sprite2D").flip_h:
			player.velocity.x = -player.jump_velocity
		else:
			player.velocity.x = player.jump_velocity
		transitioned.emit(self, "Fall")
	if event.is_action_pressed("slash"):
		transitioned.emit(self, "Attack")
	elif event.is_action_pressed("dash"):
		transitioned.emit(self, "Dash")
	elif event.is_action_pressed("switch"):
		player.switch_mode()
	elif event.is_action_pressed("shoot"):
		transitioned.emit(self, "Shoot")
