extends Button

func _ready():
	connect("pressed", _on_MainMenu_button_pressed)

func _on_MainMenu_button_pressed():
	get_tree().change_scene_to_file("res://menus/TitleScreen.tscn")
