extends Control



func _on_ready() -> void:
	hide()
	pass # Replace with function body.



func _on_water_value_changed(value: float) -> void:
	$MarginContainer/VBoxContainer/HBoxContainer/waterr_amt.text = str(value) + "mm"
	


func _on_fertilizer_value_changed(value: float) -> void:
	$MarginContainer/VBoxContainer/HBoxContainer2/fertilizer_amt.text = str(value) + "%"
	
	pass # Replace with function body.


func _on_texture_rect_gui_input(event: InputEvent) -> void:
	hide()
	pass # Replace with function body.
