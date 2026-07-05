extends Node2D

@export var drag_sensitivity := 1.0
@onready var world = $World
@onready var player: CharacterBody2D = $Player


var is_dragging = false
var drag_start_mouse: Vector2
var drag_start_world: Vector2


func _input(event):

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT:

		if event.pressed:
			is_dragging = true
			drag_start_mouse = event.position
			drag_start_world = world.position
		else:
			is_dragging = false

	if event is InputEventMouseMotion and is_dragging:
		var delta = (event.position - drag_start_mouse) * drag_sensitivity
		world.position = drag_start_world + delta

func stop_drag():
	is_dragging = false
