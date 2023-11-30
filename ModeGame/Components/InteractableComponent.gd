extends Area2D

class_name Interactable

@export var interactable_radius = 50
@export var interact_object: Node2D

var interactable = false

func _ready():
	interactable = true
	self.connect("area_entered", _on_area_entered)
	self.connect("area_exited", _on_area_exited)

func _on_area_entered(area):
	if area.is_in_group("player"):
		interact_object.show()

func _on_area_exited(area):
	if area.is_in_group("player"):
		interact_object.hide()
