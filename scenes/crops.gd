extends TileMapLayer

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("left_click"):
		var tile = local_to_map(get_global_mouse_position())
		set_cell(tile, 2, Vector2i(1, 1))

	if Input.is_action_just_pressed("right_click"):
		var tile = local_to_map(get_global_mouse_position())
		set_cell(tile, 0, Vector2i(0, -1))
