extends State
class_name Dash


var first_enter = true

func enter():
	

	if first_enter:
		player.animationPlayer.connect("animation_finished", on_animation_finished)
	
	if player.abilities.has("dash"):
		print(player.animationPlayer)
		player.animationPlayer.play("Dash")
		player.velocity = get_direction() * player.speed * 5



func process(_delta):
	if not player.abilities.has("dash"):
		transitioned.emit(self, "Fall")

func on_animation_finished(anim_name):
	print("Dash finished")
	print(anim_name)
	if anim_name == "Dash":
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
