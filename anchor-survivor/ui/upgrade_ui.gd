extends CanvasLayer

signal upgrade_selected(type)

func _ready():
	$Panel/ButtonA.pressed.connect(func(): choose("damage"))
	$Panel/ButtonB.pressed.connect(func(): choose("speed"))
	$Panel/ButtonC.pressed.connect(func(): choose("hp"))

func choose(type):
	emit_signal("upgrade_selected", type)
	get_tree().paused = false
	queue_free()
