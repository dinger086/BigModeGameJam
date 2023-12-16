extends State
class_name AttackEnemy

func process(delta):
	if player.is_hooked:
		transitioned.emit(self, "Hooked")
	var distance = player.global_position.distance_to(player.target.global_position)
	if distance > player.attack_range:
		transitioned.emit(self, "MoveToward")
	attack(player.target.global_position)


func attack(target: Vector2):
	var direction = target - player.global_position

	direction = direction.normalized()

	player.slash_scene.position = direction * 32
	var angle = direction.angle_to(Vector2.LEFT) * 3 * 5
	player.slash_scene.rotation = angle

	var attack_component = player.slash_scene.get_node("HitBoxComponent")
	attack_component.attack()


