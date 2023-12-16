extends State
class_name ShooterAttack

var shoot_time = 1.0
var timer = null

func startup():
	timer = Timer.new()
	timer.set_wait_time(shoot_time)
	timer.connect("timeout", attack)
	player.add_child(timer)

func enter():
	print("ShooterAttack")
	timer.start()

func process(_delta):
	if player.is_hooked:
		transitioned.emit(self, "Hooked")
	if player.target == null:
		transitioned.emit(self, "IdleEnemy")
		return
	var distance = player.global_position.distance_to(player.target.global_position)
	if distance > player.attack_range:
		transitioned.emit(self, "IdleEnemy")

func attack():
	if player.target == null:
		return
	print("ShooterAttack: attack")
	var direction = player.target.global_position - player.global_position
	direction = direction.normalized()
	player.bullet_spawner.spawn_bullet(direction)

func exit():
	timer.stop()
