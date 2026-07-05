extends Node

@export var enemy_a_scene: PackedScene
@export var enemy_b_scene: PackedScene

var timer: float = 0.0

var candidate_count: int = 12
var min_enemy_gap: float = 72.0


func _process(delta: float) -> void:
	var wm = get_tree().get_first_node_in_group("wave_manager")
	var player = get_tree().get_first_node_in_group("player")
	var world = get_tree().get_first_node_in_group("world")

	if wm == null or player == null or world == null:
		return

	timer += delta

	if timer < wm.spawn_interval:
		return

	timer = 0.0

	if get_tree().get_nodes_in_group("enemy").size() >= wm.max_enemies:
		return

	_spawn_enemy_deferred(player.global_position, world, wm)


# ✔ 普通刷怪（安全延迟执行）
func _spawn_enemy_deferred(player_pos: Vector2, world: Node, wm: Node) -> void:
	call_deferred("_do_spawn_enemy", player_pos, world, wm)


func _do_spawn_enemy(player_pos: Vector2, world: Node, wm: Node) -> void:
	var pos := _find_position(player_pos, wm)

	if pos == Vector2.INF:
		return

	var wm2 = get_tree().get_first_node_in_group("wave_manager")
	var wave = wm2.wave if wm2 != null else 1

	var scene = _get_enemy_scene(wave)
	var enemy = scene.instantiate()
	world.add_child(enemy)
	enemy.global_position = pos


# ✔ 波次爆发（同样 deferred）
func _on_wave_changed(_wave: int, burst_count: int) -> void:
	var wm = get_tree().get_first_node_in_group("wave_manager")
	var player = get_tree().get_first_node_in_group("player")
	var world = get_tree().get_first_node_in_group("world")

	if wm == null or player == null or world == null:
		return

	for i in range(burst_count):
		if get_tree().get_nodes_in_group("enemy").size() >= wm.max_enemies:
			break

	var wave = wm.wave

	var scene = _get_enemy_scene(wave)
	_spawn_enemy_deferred_with_scene(scene, player.global_position, world, wm)

func _find_position(center: Vector2, wm: Node) -> Vector2:
	var best_pos := Vector2.INF
	var best_score := -INF

	for i in range(candidate_count):
		var angle := randf() * TAU
		var dist := randf_range(wm.min_radius, wm.max_radius)
		var candidate := center + Vector2(cos(angle), sin(angle)) * dist

		var score := _score(candidate)

		if score > best_score:
			best_score = score
			best_pos = candidate

	if best_score < -9000:
		return Vector2.INF

	return best_pos


func _score(pos: Vector2) -> float:
	var score := 0.0

	for e in get_tree().get_nodes_in_group("enemy"):
		if e is not Node2D:
			continue

		var d := pos.distance_to(e.global_position)

		if d < min_enemy_gap:
			score -= 10000.0

		score += d

	return score
	
func _get_enemy_scene(wave: int) -> PackedScene:
	if wave <= 2:
		return enemy_a_scene
	elif wave <= 5:
		if randf() < 0.5:
			return enemy_a_scene  
		else:
			return enemy_b_scene	
	else:
		return enemy_b_scene

func _spawn_enemy_deferred_with_scene(scene: PackedScene, player_pos: Vector2, world: Node, wm: Node) -> void:
	call_deferred("_do_spawn_enemy_with_scene", scene, player_pos, world, wm)

func _do_spawn_enemy_with_scene(scene: PackedScene, player_pos: Vector2, world: Node, wm: Node) -> void:
	var pos := _find_position(player_pos, wm)

	if pos == Vector2.INF:
		return

	var enemy = scene.instantiate()
	world.add_child(enemy)
	enemy.global_position = pos
