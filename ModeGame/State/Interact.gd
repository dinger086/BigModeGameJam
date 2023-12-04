extends State
class_name Interact


var interactable = null
var finished = false

func enter():
	var interaction = player.get_node("InteractionPlayer")
	if interaction.can_interact and interaction.interactable:
		interactable = interaction.interactable
		print(interactable.action)
		interaction.interactable.interact()
		finished = false
		var action = interactable.action
		if action["type"] == "dialogue":
			display_text(action["text"])

func process(_delta):
	#print(interactable)
	if interactable != null:
		player.velocity = Vector2.ZERO
		if finished:
			interactable = null
	else:
		transitioned.emit(self, "Idle")


func input(event):
	if event.is_action_pressed("interact"):
		print("interact")
		close_text()
		finished = true


func display_text(text):
	print("displaying text")
	var dialogue_box = get_node("/root/Game/UI/DialogueBox")
	var text_box = get_node("/root/Game/UI/DialogueBox/TextBox")
	dialogue_box.visible = true
	text_box.text = text

func close_text():
	var dialogue_box = get_node("/root/Game/UI/DialogueBox")
	dialogue_box.visible = false