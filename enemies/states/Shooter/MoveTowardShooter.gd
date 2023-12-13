extends State
class_name MoveTowardShooter

func startup():
	var sight = player.get_node("Sight")
	sight.connect("sighted", activate)
	sight.connect("lost_sight", deactivate)


func process(_delta):
	if player.is_hooked:
		transitioned.emit(self, "Hooked")
	if player.target == null:
		transitioned.emit(self, "IdleEnemy")
		return
	move_to(player.target.global_position)

	var distance = player.global_position.distance_to(player.target.global_position)
	
	if distance < player.attack_range:
		transitioned.emit(self, "ShooterAttack")

func move_to(target):
	var direction = (target - player.global_position).normalized()
	player.velocity.x = direction.x * player.speed

func deactivate():
	print("Lost sight of player")
	player.target = null
	player.active = false
	transitioned.emit(self, "IdleEnemy")

func activate(target):
	player.target = target
	player.active = true
	transitioned.emit(self, "MoveTowardShooter")
