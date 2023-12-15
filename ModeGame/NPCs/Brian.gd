extends Node2D

@onready var interaction = $Interaction
@export var text = "Hello"


func _ready():
	interaction.connect("interacted" , _on_interaction)

func _on_interaction():
	interaction.action = {
		"type": "dialogue",
		"text": text
	}
