class_name Damaged
extends State

func startup():
	# TODO: play damaged animation
	pass

func enter():
	# Should push you mostly hornizontally away from the attack with a little bit of vertical knockback
	player.velocity = knockback()
	player.attack_location = Vector2(0, 0)
	player.damaged = false
	player.grapple_hook = null 

func process(_delta):
	transitioned.emit(self, "Fall")


func physics_process(delta):
	player.velocity.y += player.gravity * delta

func knockback() -> Vector2:
	var knockback_vec = player.damage_knockback
	if player.attack_location.x - player.position.x > 0:
		knockback_vec.x = -player.damage_knockback.x
	else:
		knockback_vec.x = player.damage_knockback.x
	return knockback_vec

