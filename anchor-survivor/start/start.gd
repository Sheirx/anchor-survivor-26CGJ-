extends Control  # 如果你的根节点是 Control，就用这个；如果是 Node2D 也同理

var is_switching = false  # 防重复触发标志

func _input(event: InputEvent):
	# 防止在切换过程中再次触发
	if is_switching:
		return

	# 1. 检测键盘按键（按下瞬间，且忽略按住不放的重复回显）
	if event is InputEventKey and event.pressed and not event.echo:
		switch_to_next_scene()
		return  # 触发后直接返回，避免同一个操作导致两次切换

	# 2. 检测鼠标按键（左键、右键、中键等任意按下）
	if event is InputEventMouseButton and event.pressed:
		switch_to_next_scene()

func switch_to_next_scene():
	is_switching = true
	# 把 "res://下一场景.tscn" 改成你实际要跳转的场景路径
	get_tree().change_scene_to_file("res://levels/main_scene.tscn")
