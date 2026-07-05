extends ParentEnemy

var dir: Vector2 = Vector2.ZERO
var timer: float = 0.0

@export var speed: float = 80.0
@export var change_time_min: float = 0.3
@export var change_time_max: float = 1.0

func _ready():
	_pick_new_dir()

func _physics_process(delta):
	timer -= delta

	if timer <= 0:
		_pick_new_dir()

	velocity = dir * speed
	move_and_slide()

func _pick_new_dir():
	dir = Vector2.RIGHT.rotated(randf() * TAU)
	timer = randf_range(change_time_min, change_time_max)
