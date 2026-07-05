extends CharacterBody2D


@export var bullet_scene: PackedScene
@onready var muzzle = $Marker2D
@onready var shoot_timer: Timer = $ShootTimer
@onready var hit_cd = $HitCooldown
@onready var level_sound = $LevelUp
@onready var die_sound: AudioStreamPlayer2D = $DieSound
@onready var animated_sprite_2d: Sprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var texture_progress_bar: TextureProgressBar = $HPBar/TextureProgressBar
@onready var game_over_ui = preload("res://dead/dead.tscn")


#经验升级系统
var exp: int = 0
var level := 1
var exp_to_next := 10

#玩家每秒掉血系统
@export var hp_tick_damage := 1
@export var hp_tick_interval := 1.0
var tick_timer := 0.0

#血量
var hp := 100
var can_be_hit := true
var can_bullet: bool = true

var bullet_damage := 10
var move_speed := 200


func _ready():
	shoot_timer.timeout.connect(_shoot)

	# ✔ 初始化血条
	_sync_hp_bar()


func _process(delta):
	tick_timer += delta

	if tick_timer >= hp_tick_interval:
		tick_timer = 0.0
		take_damage(hp_tick_damage)


# =========================
# 子弹
# =========================
func _shoot():
	if can_bullet:
		var bullet = bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)

		bullet.global_position = muzzle.global_position
		bullet.damage = bullet_damage
		bullet.speed = move_speed
		bullet.direction = Vector2.RIGHT


# =========================
# 血量系统（核心修改点）
# =========================
func take_damage(dmg: int):
	if not can_be_hit:
		return

	hp -= dmg
	print("HP:", hp)

	_sync_hp_bar()  # ✔ 每次掉血更新UI

	if hp <= 0:
		die()
	else:
		_hit_cooldown()


func _sync_hp_bar():
	if texture_progress_bar:
		texture_progress_bar.max_value = 100
		texture_progress_bar.value = hp


func die():
	if die_sound.playing:
		return

	animated_sprite_2d.visible = false
	collision_shape_2d.queue_free()
	can_bullet = false
	die_sound.play()
	await die_sound.finished
	game_over()
	
	#queue_free()


# =========================
# 受击冷却
# =========================
func _hit_cooldown():
	can_be_hit = false
	hit_cd.start()


func _on_hit_cooldown_timeout():
	can_be_hit = true


# =========================
# 经验系统
# =========================
func add_exp(amount: int):
	exp += amount

	if exp >= exp_to_next:
		level_sound.play()
		level_up()


func level_up():
	level += 1
	exp -= exp_to_next
	exp_to_next += 5
	show_upgrade_ui()


func show_upgrade_ui():
	# 通知主场景停止拖拽
	if get_parent().has_method("stop_drag"):
		get_parent().stop_drag()

	get_tree().paused = true

	var ui = preload("res://ui/upgrade_ui.tscn").instantiate()
	get_tree().root.add_child(ui)

	ui.upgrade_selected.connect(apply_upgrade)


func apply_upgrade(type):
	match type:
		"damage":
			bullet_damage += 5
			print("Damage:", bullet_damage)

		"speed":
			move_speed += 100
			print("Speed:", move_speed)

		"hp":
			hp += 20
			_sync_hp_bar()  # ✔ 加血后同步UI
			print("HP:", hp)
			
func game_over():
	get_tree().paused = true

	var ui_instance = game_over_ui.instantiate()

	# 不要 add_child(ui_instance)
	get_tree().current_scene.add_child(ui_instance)

	ui_instance.show_game_over()
