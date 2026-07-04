extends CharacterBody2D


@export var bullet_scene: PackedScene
@onready var muzzle = $Marker2D
@onready var shoot_timer: Timer = $ShootTimer
@onready var hit_cd = $HitCooldown
@onready var level_sound = $LevelUp
@onready var die_sound: AudioStreamPlayer2D = $DieSound
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D



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

func _process(delta):
	tick_timer += delta

	if tick_timer >= hp_tick_interval:
		tick_timer = 0.0
		take_damage(hp_tick_damage)

func _ready():
	shoot_timer.timeout.connect(_shoot)

func _shoot():
	if can_bullet:
		var bullet = bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)

		bullet.global_position = muzzle.global_position
		bullet.direction = Vector2.RIGHT  # 先固定方向

func take_damage(dmg: int):
	if not can_be_hit:
		return

	hp -= dmg
	print("HP:", hp)

	if hp <= 0:
		die()
	else:
		_hit_cooldown()
		
func die():
	if die_sound.playing:
		return
	animated_sprite_2d.visible = false
	collision_shape_2d.queue_free()
	can_bullet = false
	die_sound.play()
	await die_sound.finished
	queue_free()


func _hit_cooldown():
	can_be_hit = false
	hit_cd.start()

func _on_hit_cooldown_timeout():
	can_be_hit = true
	
#下面是经验系统
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
	get_tree().paused = true

	var ui = preload("res://ui/upgrade_ui.tscn").instantiate()
	get_tree().root.add_child(ui)

	ui.upgrade_selected.connect(apply_upgrade)

func apply_upgrade(type):
	match type:
		"damage":
			print("damage up")
		"speed":
			print("speed up")
		"hp":
			hp += 20
