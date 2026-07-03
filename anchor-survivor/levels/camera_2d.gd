extends Camera2D

var is_dragging = false
var drag_start_screen_pos: Vector2   # 鼠标按下的屏幕像素位置
var drag_start_camera_offset: Vector2

func _input(event):
	# 鼠标按下/抬起
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			drag_start_screen_pos = event.position          # 记录屏幕坐标
			drag_start_camera_offset = offset               # 记录当前偏移
		else:
			is_dragging = false

	# 鼠标移动（拖拽中）
	if event is InputEventMouseMotion and is_dragging:
		var drag_delta = event.position - drag_start_screen_pos   # 屏幕上的像素移动量
		
		# 关键：加号 = 鼠标往上，物体往上（“抓手”手感）
		offset = drag_start_camera_offset - drag_delta
