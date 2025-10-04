extends Control

signal input_received

@onready var rich_text: RichTextLabel = $RichTextLabel

func _ready() -> void:
	
	hide()

# Public API: characters just call this with their dialog lines
func start_dialog(dialog: Array) -> void:
	show()
	for phrase in dialog:
		# Show line
		rich_text.show_text( phrase["speaker"] +" : "+ phrase["text"])
		# Wait for player input before continuing
		await wait_for_input()
	hide()
	return

# Helper to wait for button press
func wait_for_input() -> void:
	await input_received

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		emit_signal("input_received")


func _on_texture_rect_gui_input(event: InputEvent) -> void:
	pass # Replace with function body.
