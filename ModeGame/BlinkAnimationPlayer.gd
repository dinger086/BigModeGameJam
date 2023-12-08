extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_hurt_box_component_invincibility_ended():
	self.play("Stop")


func _on_hurt_box_component_invincibility_started():
	self.play("Start")
