extends CharacterBody2D


@export var bullet_scene: PackedScene
@onready var muzzle = $Marker2D
@onready var shoot_timer: Timer = $ShootTimer
@onready var hit_cd = $HitCooldown
var exp: int = 0
var level := 1
var exp_to_next := 10



var hp := 100
var can_be_hit := true

func _ready():
	shoot_timer.timeout.connect(_shoot)

func _shoot():
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
		level_up()
		
func level_up():
	level += 1
	exp -= exp_to_next
	exp_to_next += 5

	print("LEVEL UP:", level)
