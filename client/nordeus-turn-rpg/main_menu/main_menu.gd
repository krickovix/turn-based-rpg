extends Control

const MAP_PATH = "res://map/map.tscn"
const RUN_CONFIG_REQ_URL = "http://127.0.0.1:8000/run/new"


func _on_start_button_pressed() -> void:
	$StartButton.disabled = true
	$StartButton.text = "Loading..."
	fetch_run_config()
	
func fetch_run_config() -> void:
	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(on_run_config_response)
	
	var error = http.request(RUN_CONFIG_REQ_URL)
	if(error != OK):
		print("Failed to send request: ", error)


func on_run_config_response(result, code, _headers, body) -> void:
	if code != 200:
		print("Server returned status ", code)
		return
	
	var json = JSON.parse_string(body.get_string_from_utf8())
	if json == null:
		print("Failed to parse JSON")
		return
	
	GameState.start_new_run(json)
	get_tree().change_scene_to_file(MAP_PATH)
