extends Area2D

class_name Interactable

@export var interaction_radius = 10

var interaction_arrow = null

signal interacted
var action:Dictionary = {}

func _ready():
	var shape = $CollisionShape2D
	shape.scale = Vector2(interaction_radius, interaction_radius)
	self.connect("body_entered", _on_area_entered)
	self.connect("body_exited", _on_area_exited)

func _on_area_entered(body):
	if body.is_in_group("Player"):
		make_arrow()

func _on_area_exited(body):
	if body.is_in_group("Player"):
		interaction_arrow.queue_free()

func make_arrow():
	interaction_arrow = load("res://ModeGame/NPCs/Interactable_arrow.tscn").instantiate()
	interaction_arrow.position = Vector2(0, -100)
	add_child(interaction_arrow)

func interact():
	print("Interacted with " + str(self))
	emit_signal("interacted")


func display_text(text):
	var dialogue_box = get_node("/root/Game/UI/DialogueBox")
	var text_box = get_node("/root/Game/UI/DialogueBox/TextBox")
	var player = get_node("/root/Game/Player")
	player.set_pause(true)
	dialogue_box.visible = true
	text_box.text = text
