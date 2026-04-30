extends Control

const MAP_PATH = "res://map/map.tscn"
const RUN_CONFIG_REQ_URL = "http://127.0.0.1:8000/run/new"


func _on_start_button_pressed() -> void:
	$StartButton.disabled = true
	$StartButton.text = "Loading..."
	await APIClient.get_run_config()
	RunState.start_new_run()
	get_tree().change_scene_to_file(MAP_PATH)
