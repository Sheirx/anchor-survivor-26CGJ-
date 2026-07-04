extends Area2D

@export var speed := 700.0
var direction := Vector2.RIGHT
var damage := 10

func _process(delta):
	global_position += direction * speed * delta


func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
