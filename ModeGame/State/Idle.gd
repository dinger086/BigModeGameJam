extends State
class_name Idle


func enter():
	player.play("Idle")

func process(_delta):
	if player.velocity.x != 0:
		transitioned.emit(self, "Walk")
		return
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
		transitioned.emit(self, "Walk")


func physics_process(_delta):
	if not player.is_on_floor():
		transitioned.emit(self, "Fall")

func input(event):
	if event.is_action_pressed("jump"):
		transitioned.emit(self, "Jump")
	elif event.is_action_pressed("slash"):
		transitioned.emit(self, "Attack")
	elif event.is_action_pressed("dash"):
		transitioned.emit(self, "Dash")
	elif event.is_action_pressed("interact"):
		transitioned.emit(self, "Interact")