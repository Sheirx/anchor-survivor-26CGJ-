extends Area2D

@export var exp_value := 1

var player: Node2D


func _ready():
	player = get_tree().get_first_node_in_group("player")
	body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.add_exp(exp_value)
		queue_free()
