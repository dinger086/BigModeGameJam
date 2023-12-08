extends Control

func _input(event):
	#pauses the game when the escape key is pressed
	if event.is_action_pressed("pause"):
		var new_state = !get_tree().paused
		get_tree().paused = new_state
		visible = new_state
