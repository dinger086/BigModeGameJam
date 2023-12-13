extends State
class_name Swinging

var grapple_length = 0

func enter():
	grapple_length = player.grapple_hook.get_length()

func process(delta):
	if player.grapple_hook == null:
		print("No longer in wall")
		transitioned.emit(self, "Fall")
		return
	if not Input.is_action_pressed("shoot"):
		print("Let go of grapple")
		transitioned.emit(self, "Fall")
		return



func physics_process(delta):
	move_to(delta, player.grapple_hook.global_position)
	player.velocity.y += player.gravity * delta

	#pendulum_motion(delta)


func move_to(delta, target):
	var direction = target - player.global_position
	direction = direction.normalized()
	var speed = player.speed * 1000
	if speed > grapple_length:
		speed = grapple_length
	player.velocity = direction * speed


	