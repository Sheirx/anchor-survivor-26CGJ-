extends CanvasLayer

signal upgrade_selected(type)

func _ready():
	$Panel/ButtonA.pressed.connect(func(): choose("damage"))
	$Panel/ButtonB.pressed.connect(func(): choose("speed"))
	$Panel/ButtonC.pressed.connect(func(): choose("hp"))
	$Panel/ButtonD.pressed.connect(func(): choose("bullet"))

func choose(type):
	emit_signal("upgrade_selected", type)
	get_tree().paused = false
	queue_free()
