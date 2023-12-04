extends Node2D

@onready var interaction = $Interaction

func _ready():
	interaction.connect("interacted" , _on_interaction)

func _on_interaction():
	interaction.action = {
		"type": "dialogue",
		"text": "Hello, I'm Brian from the hit show Family Guy!"
	}