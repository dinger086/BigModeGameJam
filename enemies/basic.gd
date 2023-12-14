extends EnemyBody2D

@onready var slash_scene = $EnemySlash
var speed = 100
var attack_range = 50

var target = null

var active = false

var is_hooked = false
var hooked_to = null

func _ready():
	super._ready()

func _process(_delta):
	pass
