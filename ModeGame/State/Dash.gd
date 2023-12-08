extends State
class_name Dash

func enter():
	player.velocity = get_direction() * 2000



func process(_delta):
	transitioned.emit(self, "Fall")


func get_direction() -> Vector2:
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1.5
	if Input.is_action_pressed("move_left"):
		direction.x -= 1.5
	if Input.is_action_pressed("move_down"):
		direction.y += 0.5
	if Input.is_action_pressed("move_up"):
		direction.y -= 0.5
	return direction
