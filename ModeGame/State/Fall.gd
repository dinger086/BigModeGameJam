extends State
class_name Fall

var start_time = 0

func enter():
	player.play("Fall")
	start_time = Time.get_ticks_msec()

func process(_delta):
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
	elif player.is_on_wall():
			transitioned.emit(self, "Wall")
	player.velocity.y += player.gravity * delta


func input(event):
	if event.is_action_pressed("jump") and player.double_jump: 
		if Time.get_ticks_msec() - start_time > player.coyote_time:
			player.double_jump = false
		transitioned.emit(self, "Jump")
	elif event.is_action_pressed("slash"):
		transitioned.emit(self, "Attack")
	elif event.is_action_pressed("dash"):
		transitioned.emit(self, "Dash")
	elif event.is_action_pressed("switch"):
		player.switch_mode()

