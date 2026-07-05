extends CanvasLayer

@onready var exit: Button = $DeadUI/Exit
@onready var restart: Button = $DeadUI/Restart




func _ready() -> void:
	#初始隐藏
	visible = false
	
	#确保按钮焦点
	exit.focus_mode = Control.FOCUS_NONE
	restart.focus_mode = Control.FOCUS_NONE
	
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	
func show_game_over():
	print("show")
	visible = true
	get_tree().paused = true
	
	#设置按钮焦点
	restart.grab_focus()

func hide_game_over():
	visible = false
	get_tree().paused = false


func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://start/start.tscn")


func _on_restart_pressed() -> void:
	hide_game_over()
	get_tree().reload_current_scene()
