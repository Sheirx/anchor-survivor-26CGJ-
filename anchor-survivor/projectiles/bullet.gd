extends Area2D

@export var speed := 700.0
@export var lifetime := 1.5

var direction := Vector2.RIGHT
var damage := 10

func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _process(delta):
	global_position += direction * speed * delta

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
