extends State
class_name MoveToward

func startup():
	var sight = player.get_node("Sight")
	sight.connect("sighted", activate)
	sight.connect("lost_sight", deactivate)


func process(delta):
	if player.is_hooked:
		transitioned.emit(self, "Hooked")
	if player.target == null:
		transitioned.emit(self, "IdleEnemy")
		return

	var direction = (player.target.global_position - player.global_position).normalized()
	player.velocity.x = move_toward(player.velocity.x, direction.x * player.speed, 2000*delta)

	var distance = player.global_position.distance_to(player.target.global_position)
	
	if distance < player.attack_range:
		transitioned.emit(self, "AttackEnemy")

	


func deactivate():
	print("Lost sight of player")
	player.active = false
	transitioned.emit(self, "IdleEnemy")

func activate(target):
	player.target = target
	player.active = true
	transitioned.emit(self, "MoveToward")