extends Control

var buttons = []
var current_button : int = 0

@onready var StartButton : Button = get_node("MarginContainer/VBoxContainer/StartButton")
@onready var SettingsButton : Button = get_node("MarginContainer/VBoxContainer/SettingsButton")
@onready var QuitButton : Button = get_node("MarginContainer/VBoxContainer/QuitButton")

func _ready():
	StartButton.connect("pressed", _on_start_button_pressed)
	SettingsButton.connect("pressed", _on_settings_button_pressed)
	QuitButton.connect("pressed", _on_quit_button_pressed)
	for child in get_node("MarginContainer/VBoxContainer").get_children():
		if child.is_class("Button"):
			buttons.append(child)
	buttons[current_button].grab_focus()

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://ModeGame/Game.tscn")

func _on_settings_button_pressed():
	get_tree().change_scene_to_file("res://menus/Settings.tscn")
	self.visible = true

func _on_quit_button_pressed():
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("ui_right"):
		change_focus(-1)
	elif event.is_action_pressed("ui_left"):
		change_focus(1)

func change_focus(direction:int):
	current_button += direction
	if current_button < 0:
		current_button = buttons.size() - 1
	elif current_button >= buttons.size():
		current_button = 0
	buttons[current_button].grab_focus()
