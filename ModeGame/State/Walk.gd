extends State
class_name Walk

func enter():
	player.play("Run")
	player.get_node("WalkingSound").play(0.6)
	player.footsteps.emitting = true
	
func exit():
	player.footsteps.emitting = false
	player.get_node("WalkingSound").stop()

func process(delta):
	if player.damaged:
		transitioned.emit(self, "Damaged")
		return
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			player.velocity.x = move_toward(player.velocity.x, direction * player.speed, player.speed*.2* delta * 150)
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, player.speed*.1* delta * 150)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.speed*.1* delta * 150)

	if not player.is_on_floor():
		transitioned.emit(self, "Fall")
		
	if player.velocity == Vector2.ZERO:
		transitioned.emit(self, "Idle")


func input(event):
	if event.is_action_pressed("jump"):
		transitioned.emit(self, "Jump")
	elif event.is_action_pressed("slash"):
		transitioned.emit(self, "Attack")
	elif event.is_action_pressed("dash"):
		transitioned.emit(self, "Dash")
	elif event.is_action_pressed("interact"):
		transitioned.emit(self, "Interact")
	elif event.is_action_pressed("switch"):
		player.switch_mode()
	elif event.is_action_pressed("shoot"):
		transitioned.emit(self, "Shoot")
