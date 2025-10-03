extends Control



func _on_ready() -> void:
	hide()
	pass # Replace with function body.



func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		hide()
	pass # Replace with function body.
