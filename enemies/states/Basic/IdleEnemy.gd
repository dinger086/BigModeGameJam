extends State
class_name IdleEnemy

func process(_delta):
	if player.active:
		print(get_parent().initial_state.name)
		transitioned.emit(self, get_parent().initial_state.name)
	if player.is_hooked:
		transitioned.emit(self, "Hooked")

