extends State
class_name Idle

var press_time = 0.0
var is_holding = false
var camera

func enter():
	player.play("Idle")
	camera = player.get_node("Camera2D")
	press_time = Time.get_ticks_msec()
	is_holding = true

func process(_delta):
	if player.damaged:
		transitioned.emit(self, "Damaged")
		return
	if player.velocity.x != 0:
		transitioned.emit(self, "Walk")
		return
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
		transitioned.emit(self, "Walk")

	if is_holding:
		if Time.get_ticks_msec() - press_time > 500:
			if Input.is_action_pressed("move_up"):
				camera.offset.y = -100
			elif Input.is_action_pressed("move_down"):
				camera.offset.y = 100
	else:
		camera.offset.y = 0

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
	elif event.is_action_pressed("switch"):
		player.switch_mode()
	elif event.is_action_pressed("shoot"):
		transitioned.emit(self, "Shoot")

	if event.is_action_pressed("move_up"):
		is_holding = true
		press_time = Time.get_ticks_msec()
	if event.is_action_released("move_up"):
		is_holding = false
		press_time = 0.0
	if event.is_action_pressed("move_down"):
		is_holding = true
		press_time = Time.get_ticks_msec()
	if event.is_action_released("move_down"):
		is_holding = false
		press_time = 0.0

func exit():
	is_holding = false
	camera.offset.y = 0
