extends Node2D

@onready var interaction = $Interaction

func _ready():
	interaction.connect("interacted" , _on_interaction)

func _on_interaction():
	interaction.display_text("Hello I'm Brian!")