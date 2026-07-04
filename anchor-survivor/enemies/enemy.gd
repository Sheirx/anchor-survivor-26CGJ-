extends CharacterBody2D

@export var hp := 30
@export var damage := 30

var player_in_area := false


func take_damage(dmg: int):
	hp -= dmg

	if hp <= 0:
		drop_exp()
		queue_free()


func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_area = true


func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_area = false


func _on_timer_timeout():
	if player_in_area:
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.take_damage(damage)
			
#掉经验
func drop_exp():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.add_exp(5)
