extends EnemyBody2D

@onready var slash_scene = $EnemySlash
@onready var player = $AnimationPlayer
var speed = 100
var attack_range = 50

var target = null

var active = false

var is_hooked = false
var hooked_to = null

func _ready():
	super._ready()
	player.play("Move")


func _process(_delta):
	if velocity.x > 0:
		$Sprite.flip_h = true
	elif velocity.x < 0:
		$Sprite.flip_h = false
