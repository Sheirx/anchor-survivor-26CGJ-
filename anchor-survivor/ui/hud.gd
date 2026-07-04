extends CanvasLayer


@onready var exp_bar: TextureProgressBar = $EXP/ExpBar
@onready var level_label: Label = $EXP2/LevelLabel

var player = null


func _ready():
	player = get_tree().get_first_node_in_group("player")


func _process(delta):
	if player == null:
		return

	_update_exp()
	_update_level()


func _update_exp():
	exp_bar.max_value = player.exp_to_next
	exp_bar.value = player.exp


func _update_level():
	level_label.text = "Lv " + str(player.level)
