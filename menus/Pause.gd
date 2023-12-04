extends Control

func _input(event):
	print(event)
	if event.is_action_pressed("pause"):
		var new_pause_state = not get_tree().paused
		get_tree().paused = not new_pause_state
		visible = new_pause_state
		print(new_pause_state)
