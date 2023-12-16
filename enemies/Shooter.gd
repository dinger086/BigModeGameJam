
extends EnemyBody2D

@onready var bullet_spawner = $BulletSpawner
@onready var animation = $AnimationPlayer

var speed = 100
var attack_range = 1000
var attack_speed_time = 1.0

var active = false
var target = null

var is_hooked = false
var hooked_to = null

func _ready():
	super._ready()
	self.do_gravity = false
	animation.play("fly")


func _process(_delta):
	if is_on_floor():
		self.velocity.y = 10
