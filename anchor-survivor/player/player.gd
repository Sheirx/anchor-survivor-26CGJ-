extends CharacterBody2D
var can_laser: bool = true
var can_gernade: bool = true
@export var speed:int = 500
signal laser(pos,direction)
signal gernade(pos,direction)

func _process(_delta: float) -> void:
	var direction = Input.get_vector("right","left","down","up")
	velocity = direction * speed
	move_and_slide()
	Globals.player_pos = global_position
