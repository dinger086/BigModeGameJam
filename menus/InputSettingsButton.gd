extends Button

func _ready():
	connect("pressed", _on_InputSettings_button_pressed)

func _on_InputSettings_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menus/InputSettings.tscn")
