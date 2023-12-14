extends HBoxContainer

@export var player: Node2D

@onready var attack_bar: ProgressBar = $Attack
@onready var dash_bar: ProgressBar = $Dash
@onready var shoot_bar: ProgressBar = $Shoot

# Death abilities
# attack, slash_fury, grappling_hook
# Life abilities
# attack, shield_bash, projectile

func _ready():
	set_bars(player.mode)
	player.connect("switched_mode",set_bars)

func set_bars(mode):
	if not mode:
		attack_bar.max_value = player.ability_cooldowns_times["attack"]
		dash_bar.max_value = player.ability_cooldowns_times["shield_bash"]
		shoot_bar.max_value = player.ability_cooldowns_times["projectile"]
	else:
		attack_bar.max_value = player.ability_cooldowns_times["attack"]
		dash_bar.max_value = player.ability_cooldowns_times["slash_fury"]
		shoot_bar.max_value = player.ability_cooldowns_times["grapple_hook"]

func _process(delta):
	if not player.mode:
		attack_bar.value = bar_value("attack")
		dash_bar.value = bar_value("shield_bash")
		shoot_bar.value = bar_value("projectile")
	else:
		attack_bar.value = bar_value("attack")
		dash_bar.value = bar_value("slash_fury")
		shoot_bar.value = bar_value("grapple_hook")

func bar_value(ability:String):
	return player.ability_cooldowns_times[ability] - player.ability_cooldowns[ability]
