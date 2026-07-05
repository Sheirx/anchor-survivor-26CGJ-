extends Node

signal wave_changed(wave: int, burst_count: int)

var wave: int = 1
var kill_count: int = 0
var kills_to_next_wave: int = 4

var spawn_interval: float = 1.0
var max_enemies: int = 1000

var min_radius: float = 70
var max_radius: float = 400
var min_radius_limit: float = 15

var spawn_interval_min: float = 0.1


func _ready() -> void:
	add_to_group("wave_manager")


func add_kill() -> void:
	kill_count += 1
	if kill_count >= kills_to_next_wave:
		next_wave()


func next_wave() -> void:
	wave += 1
	kill_count = 0
	kills_to_next_wave = int(ceil(kills_to_next_wave * 1.25))

	spawn_interval = max(spawn_interval_min, spawn_interval * 0.9)
	max_enemies += 3

	min_radius = max(min_radius_limit, min_radius - 10.0)
	max_radius = max(min_radius + 80.0, max_radius - 5.0)

	var burst_count: int = 50 + int(wave * 4)

	print("WAVE:", wave, "burst:", burst_count)

	emit_signal("wave_changed", wave, burst_count)
