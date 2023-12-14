
extends EnemyBody2D

@onready var bullet_spawner = $BulletSpawner
var speed = 100
var attack_range = 1000
var attack_speed_time = 1.0

var active = false
var target = null

var is_hooked = false
var hooked_to = null

func _ready():
	super._ready()


func _process(_delta):
	pass
