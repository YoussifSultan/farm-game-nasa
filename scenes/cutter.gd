extends CharacterBody2D

@onready var talk_area: Area2D = $TalkArea
@onready var dialog_box: Node = get_node("../UI/Dialogbox")

var player_in_range: bool = false
var dialog_working: bool = false
var dialog_finished: bool = false

const DIALOG_LINES := [
	{"speaker": "cutter", "text": "Hallo, wie geht's?"},
	{"speaker": "player", "text": "Bist du gut?"},
	{"speaker": "cutter", "text": "Ich denke, dass das Wetter schlecht ist."},
	{"speaker": "player", "text": "Ja, du hast absolut Recht."}
]

func _ready() -> void:
	talk_area.body_entered.connect(_on_body_entered)
	talk_area.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		player_in_range = true
		dialog_finished = false  # reset when entering again

func _on_body_exited(body: Node) -> void:
	if body.name == "Player":
		player_in_range = false

func _input(event: InputEvent) -> void:
	if not (player_in_range and event.is_action_pressed("ui_accept")):
		return
	if dialog_working or dialog_finished:
		return

	_start_dialog()

func _start_dialog() -> void:
	dialog_working = true
	await dialog_box.start_dialog(DIALOG_LINES)
	dialog_working = false
	dialog_finished = true   # prevent repeat
