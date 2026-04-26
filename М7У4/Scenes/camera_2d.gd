extends Camera2D

var min_x := 0.0  # Минимально возможная позиция камеры

func _process(delta):
	var target_x = get_parent().global_position.x

	# камера может двигаться только вперёд (вправо)
	if target_x > min_x:
		min_x = target_x

	global_position.x = min_x
