extends Area2D

class_name Interactable

@export var interaction_radius = 10

var interaction_arrow = null

signal can_interact(can_interact)


func _ready():
	var shape = $CollisionShape2D
	shape.scale = Vector2(interaction_radius, interaction_radius)
	self.connect("body_entered", _on_area_entered)
	self.connect("body_exited", _on_area_exited)

func _on_area_entered(body):
	if body.is_in_group("Player"):
		make_arrow()
		emit_signal("can_interact", true)

func _on_area_exited(body):
	if body.is_in_group("Player"):
		interaction_arrow.queue_free()
		emit_signal("can_interact", false)

func make_arrow():
	interaction_arrow = load("res://ModeGame/NPCs/Interactable_arrow.tscn").instantiate()
	interaction_arrow.position = Vector2(0, -100)
	add_child(interaction_arrow)

func interact():
	print("Interacted with " + str(self))
	emit_signal("can_interact", false)