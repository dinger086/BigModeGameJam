extends Control

func _input(event):
	if event.is_action_pressed("pause"):
		var new_state = !get_tree().paused
		get_tree().paused = new_state
		visible = new_state
