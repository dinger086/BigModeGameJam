extends Node
class_name StateMachine

@export var initial_state:State
@export var player:Node


var current_state:State
var states:Dictionary = {}

func _ready():
	player.connect("ready", _on_player_ready)
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
			child.player = player

	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _on_player_ready():
	for child in get_children():
		if child is State:
			child.startup()

func _process(delta):
	if current_state:
		current_state.process(delta)

func _physics_process(delta):
	if current_state:
		current_state.physics_process(delta)

func _input(event):
	if current_state:
		current_state.input(event)

func on_child_transition(state, state_name):
	if state != current_state:
		return

	var next_state = states[state_name.to_lower()]

	if !next_state:
		print("StateMachine: State not found: " + state_name)
		return

	current_state.exit()

	next_state.enter()
	current_state = next_state

