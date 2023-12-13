extends State
class_name Hooked

func process(_delta):
	if player.hooked_to == null or player.hooked_to.grapple_hook == null:
		player.is_hooked = false
		player.hooked_to = null
		transitioned.emit(self, "IdleEnemy")
		return
	var distance = player.global_position.distance_to(player.hooked_to.global_position)
	if distance < 100:
		player.velocity = Vector2.ZERO
		player.is_hooked = false
		transitioned.emit(self, "Stunned")
		return
	move_to(player.hooked_to.global_position)

func move_to(target):
	var direction = (target - player.global_position).normalized()
	player.velocity.x = direction.x * 1000

