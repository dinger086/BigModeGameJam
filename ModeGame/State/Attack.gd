extends State
class_name Attack

var knockback_direction = Vector2.ZERO
var first = true
var attack_comp = null

func enter():
	if first:
		attack_comp = player.slashScene.get_node("HitBoxComponent")
		attack_comp.connect("attack_damaged", self_knockback)
		first = false

	var direction = get_direction()
	if direction == Vector2.ZERO:
		if player.get_node("Sprite2D").flip_h:
			direction.x = -1
		else:
			direction.x = 1


	knockback_direction = -direction
	player.slashScene.position = direction * 64
	var angle = direction.angle_to(Vector2.RIGHT) * 3 * 5
	player.slashScene.rotation = angle
	attack_comp.attack()
	


func self_knockback():
	player.velocity = knockback_direction * player.knockback_speed


func process(_delta):
	#Might add a way to cancel the attack
	transitioned.emit(self, "Fall")


func get_direction() -> Vector2:
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	return direction.normalized()
