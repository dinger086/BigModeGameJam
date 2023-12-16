extends State

class_name Swipe

@onready var timer


func startup():
	var timer = Timer.new()
	timer.set_wait_time(10)
	timer.connect("timeout", start_attack)
	timer.start()


func start_attack():
	player.velocity = Vector2(1,0)

func process(delta):
	player.velocity = Vector2(-1,0)
	player.move_and_slide()

	