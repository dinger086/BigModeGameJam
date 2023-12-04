extends State
class_name Jump

func enter():
	pass

func process(_delta):
	player.velocity.y = player.jump_velocity
	transitioned.emit(self, "Fall")
	