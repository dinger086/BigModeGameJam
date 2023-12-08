extends Area2D

class_name InteractionPlayer

var can_interact = false
var interactable = null

func _ready():
	self.connect("area_entered", _on_area_entered)
	self.connect("area_exited", _on_area_exited)

func _on_area_entered(body):
	if body.is_in_group("Interactable"):
		can_interact = true
		interactable = body


func _on_area_exited(body):
	if body.is_in_group("Interactable"):
		can_interact = false
		interactable = null
