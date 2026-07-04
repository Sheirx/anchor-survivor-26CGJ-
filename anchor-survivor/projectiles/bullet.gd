extends Area2D

@export var speed := 700.0
var direction := Vector2.RIGHT

func _process(delta):
	global_position += direction * speed * delta


func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(10)
	queue_free()
