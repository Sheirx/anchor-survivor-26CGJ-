extends Node

@export var enemy_scene: PackedScene
@export var spawn_interval := 2.0
@export var max_enemies := 15
@export var spawn_radius := 300.0

var timer := 0.0


func _process(delta):
	timer += delta
	if timer < spawn_interval:
		return

	timer = 0.0

	var enemies = get_tree().get_nodes_in_group("enemy")
	if enemies.size() >= max_enemies:
		return

	spawn_enemy()


func spawn_enemy():
	var player = get_tree().get_first_node_in_group("player")
	var world = get_tree().get_first_node_in_group("world")

	if player == null or world == null:
		return

	var enemy = enemy_scene.instantiate()

	var angle = randf() * TAU
	var offset = Vector2(cos(angle), sin(angle)) * spawn_radius

	world.add_child(enemy)
	enemy.global_position = player.global_position + offset
