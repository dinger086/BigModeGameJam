extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = create_tween()
	tween.set_parallel(false)
	tween.tween_method(set_shader_value, 1.0, 0.0, 0.2);
	tween.connect("finished", on_tween_finished)
	tween.play()

# tween value automatically gets passed into this function
func set_shader_value(value: float):
	# in my case i'm tweening a shader on a texture rect, but you can use anything with a material on it
	self.material.set_shader_parameter("alpha", value);
	
	
func on_tween_finished():
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
