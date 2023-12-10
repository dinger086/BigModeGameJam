extends CheckButton

var fullscreen : bool = false

func _ready():
	connect("toggled", _on_fullscreen_toggled)

func _on_fullscreen_toggled(is_checked: bool) -> void:
	if is_checked:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
