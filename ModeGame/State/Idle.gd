extends State
class_name Idle


func enter():
	print("Entering Idle State")
	player.play("Idle")

func process(delta):
	if Input.is_action_pressed("move_right"):
		transitioned.emit(self, "Walk")
	elif Input.is_action_pressed("move_left"):
		transitioned.emit(self, "Walk")
	elif Input.is_action_pressed("jump"):
		transitioned.emit(self, "Jump")
	elif Input.is_action_pressed("slash"):
		transitioned.emit(self, "Attack")

func physics_process(_delta):
	if not player.is_on_floor():
		transitioned.emit(self, "Fall")