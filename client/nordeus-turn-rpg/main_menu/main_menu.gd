extends Control

const MAP_PATH = "res://map/map.tscn"
const RUN_CONFIG_REQ_URL = "http://127.0.0.1:8000/run/new"

@onready var start_button: Button = $VBoxContainer/StartButton
@onready var confirm_pop_up: ConfirmPopUp = $ConfirmPopUp


func _ready() -> void:
	confirm_pop_up.hide()
	confirm_pop_up.set_text("Are you sure you want to exit?")
	confirm_pop_up.clicked_confirm.connect(_on_popup_clicked_confirm)

func _on_start_button_pressed() -> void:
	start_button.disabled = true
	start_button.text = "Loading..."
	await APIClient.get_run_config()
	RunState.start_new_run()
	get_tree().change_scene_to_file(MAP_PATH)

func _on_exit_pressed() -> void:
	confirm_pop_up.show()

func _on_popup_clicked_confirm() -> void:
	get_tree().quit()
