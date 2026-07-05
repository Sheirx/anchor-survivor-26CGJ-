extends CanvasLayer

signal upgrade_selected(type)

@onready var buttons = [
	$Panel/ButtonA,
	$Panel/ButtonB,
	$Panel/ButtonC,
	$Panel/ButtonD
]

var upgrade_pool = [
	{"type":"damage","text":"Damage","weight":10},
	{"type":"speed","text":"Speed","weight":10},
	{"type":"hp","text":"HP","weight":10},
	{"type":"bullet","text":"Bullet","weight":2}
]

func _ready():
	randomize()

	# 先隐藏所有按钮
	for button in buttons:
		button.visible = false

	var upgrades = get_random_upgrades(3)

	for i in range(upgrades.size()):
		var data = upgrades[i]
		var button = buttons[i]

		button.visible = true
		button.text = data["text"]

		button.pressed.connect(func():
			choose(data["type"])
		)


func weighted_pick(pool):
	var total = 0

	for item in pool:
		total += item["weight"]

	var r = randi_range(1, total)

	for item in pool:
		r -= item["weight"]
		if r <= 0:
			return item

	return pool[0]


func get_random_upgrades(count):
	var temp = upgrade_pool.duplicate(true)
	var result = []

	while result.size() < count and temp.size() > 0:
		var pick = weighted_pick(temp)
		result.append(pick)
		temp.erase(pick)

	return result


func choose(type):
	emit_signal("upgrade_selected", type)
	get_tree().paused = false
	queue_free()
