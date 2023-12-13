extends EnemyBody2D

var is_hooked = false
var hooked_to = null

var active = false

func _ready():
	super._ready()
