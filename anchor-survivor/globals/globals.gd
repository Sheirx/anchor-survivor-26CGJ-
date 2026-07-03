extends Node

signal stat_changed

var laser_amount = 20:
	get:
		return laser_amount
	set(value):
		laser_amount = value
		stat_changed.emit()
	
var grenade_amount = 10:
	get:
		return grenade_amount
	set(value):
		grenade_amount = value
		stat_changed.emit()
		
var player_vulnerable: bool = true		
var health = 60:
	get:
		return health
	set(value):
		if value >health:
			health = min(value,100)
		else:
			if player_vulnerable:
				health = max(value,0)
				player_vulnerable = false
				player_invulnerable_timer()
		stat_changed.emit()

var player_pos: Vector2

func player_invulnerable_timer():
	await get_tree().create_timer(0.5).timeout
	player_vulnerable = true
