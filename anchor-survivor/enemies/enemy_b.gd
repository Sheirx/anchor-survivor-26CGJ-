extends ParentEnemy
@export var min_scale := 4
@export var max_scale := 8
@export var scale_speed := 2.0
var t := 0.0

func _process(delta: float) -> void:
	t += delta

	var value := (sin(t * scale_speed) + 1.0) * 0.5
	# value 在 0~1

	var s: float = lerp(min_scale, max_scale, value)
	scale = Vector2(s, s)
