extends State
class_name Idle

var press_time = 0.0
var is_holding = false

func enter():
	player.play("Idle")

func process(_delta):
	if player.velocity.x != 0:
		transitioned.emit(self, "Walk")
		return
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
		transitioned.emit(self, "Walk")

	is_holding = Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down")

	if press_time != 0.0 and Time.get_ticks_msec() - press_time > 500:
		if Input.is_action_pressed("move_up"):
			lookup()
		elif Input.is_action_pressed("move_down"):
			lookdown()
		press_time = 0.0



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

	if Input.is_action_pressed("move_up") and press_time == 0.0:
		press_time = Time.get_ticks_msec()
	elif Input.is_action_pressed("move_down") and press_time == 0.0:
		press_time = Time.get_ticks_msec()
	else:
		press_time = 0.0

func lookup():
	var camera = player.get_node("Camera2D")
	camera.offset.y = -100

func lookdown():
	var camera = player.get_node("Camera2D")
	camera.offset.y = 100