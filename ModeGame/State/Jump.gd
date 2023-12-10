extends State
class_name Jump

var first_enter = true

func enter():
	player.velocity.y = player.jump_velocity
	if first_enter:
		player.animationPlayer.connect("animation_finished", on_animation_finished)
		first_enter = false
	player.animationPlayer.play("Jump")

func on_animation_finished(anim_name):
	if anim_name == "Jump":
		player.animationPlayer.play("Fall")
		transitioned.emit(self, "Fall")


func physics_process(delta):
	if player.damaged:
		transitioned.emit(self, "Damaged")
		return
	if player.is_on_floor():
		player.double_jump = true
		transitioned.emit(self, "Idle")
	elif player.is_on_wall():
			transitioned.emit(self, "Wall")
	player.velocity.y += player.gravity * delta


func process(_delta):
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			player.velocity.x = move_toward(player.velocity.x, direction * player.speed, player.speed*.2)
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, player.speed*.1)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.speed*.1)

	if not Input.is_action_pressed("jump"):
		if player.velocity.y < 0:
			player.velocity.y = move_toward(player.velocity.y, 0, player.speed*.1)
		transitioned.emit(self, "Fall")



	
