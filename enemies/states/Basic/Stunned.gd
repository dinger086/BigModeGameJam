extends State
class_name Stunned

var timer = null
var wait_time = 1.0

func startup():
	timer = Timer.new()
	timer.set_wait_time(wait_time)
	timer.connect("timeout", _on_stun_finished)
	add_child(timer)


func enter():
	timer.start()
	print("Stunned")

func _on_stun_finished():
	print("Stun finished")
	transitioned.emit(self, "IdleEnemy")

func process(_delta):
	pass

func exit():
	timer.stop()