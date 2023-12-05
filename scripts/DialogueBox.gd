extends Panel

class_name TextBox

@onready var text_box = $TextBox

func _ready():
	pass

func set_text(text):
	text_box.text = text