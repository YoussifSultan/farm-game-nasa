extends RichTextLabel

var typing_speed := 0.05 # seconds per character
var full_text := " \n  \n  \n Was hältst du davon???"
var is_typing := false

func show_text(new_text: String):
	full_text = new_text
	visible_characters = 0
	text = full_text
	is_typing = true
	start_typing()

func start_typing():
	var i = 0
	while i <= full_text.length() and is_typing:
		visible_characters = i
		await get_tree().create_timer(typing_speed * (0.01 * i)).timeout
		i += 1

	
