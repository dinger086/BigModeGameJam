extends Area2D

@export var sight_radius = 20

signal sighted(body)
signal lost_sight

func _ready():
	set_collision_mask_value(2, true)
	var sightline = $CollisionShape2D
	sightline.scale = Vector2(sight_radius, sight_radius)
	self.connect("body_entered", _on_area_entered)
	self.connect("body_exited", _on_area_exited)

func _on_area_entered(body):
	if body.is_in_group("Player"):
		emit_signal("sighted", body)

func _on_area_exited(body):
	if body.is_in_group("Player"):
		emit_signal("lost_sight")
