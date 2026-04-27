extends Node2D

const BATTLE_PATH = "res://battle/battle.tscn"
const RUN_CONFIG_REQ_URL = "http://localhost:8000/run/new"


func _ready() -> void:
	request_run_config()
	

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(BATTLE_PATH)
	
	
func request_run_config() -> void:
	var http = HTTPRequest.new()
	print("SENT")
	add_child(http)
	http.request_completed.connect(_on_response)
	http.request(RUN_CONFIG_REQ_URL)


func _on_response(_result, _code, _headers, body) -> void:
	print("HERE")
	print(body.get_string_from_utf8())
