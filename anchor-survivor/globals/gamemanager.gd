extends Node

var death_scene = preload("res://dead/dead.tscn") # 你的死亡场景路径

func show_death_screen():
	# 获取当前主场景的根节点
	var root = get_tree().current_scene
	# 实例化死亡场景并添加到主场景
	var death_ui = death_scene.instantiate()
	root.add_child(death_ui)
	
	# 暂停游戏，防止死后怪物还在动
	get_tree().paused = true
