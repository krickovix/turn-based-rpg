extends Node

const SERVER_URL = "http://127.0.0.1:8000"
const GET_RUN_CONFIG_URL = "/run/new"
const GET_NEXT_MOVE_URL = "/battle/next-move"

signal request_failed(reason: String)

func get_run_config() -> void:
	var response = await send_get(GET_RUN_CONFIG_URL, {})
	DictParser.parse_run_config(response)

func get_monster_move(monster_str_id: String, monster_hp: int, monster_max_hp: int, monster_effects: Array,
						hero_hp: int, hero_max_hp: int, hero_effects: Array, turn: int) -> Move:
						
	var params = DictParser.create_monster_move_params(monster_str_id, monster_hp, monster_max_hp, monster_effects,
														hero_hp, hero_max_hp, hero_effects, turn)
	print(params)
	var response = await send_get(GET_NEXT_MOVE_URL, params)
	if response == null:
		print("NO MONSTER RESPONSE")
		return null
	
	return DictParser.parse_next_monster_move(response)


func send_get(path: String, params: Dictionary) -> Variant:
	var query = build_query(params)
	var url = SERVER_URL + path + ("?" + query if query else "")
	
	var http = HTTPRequest.new()
	add_child(http)
	var err = http.request(url)
	if err != OK:
		http.queue_free()
		request_failed.emit("Request failed to send (err %d)" % err)
		return null
	
	var result = await http.request_completed
	http.queue_free()
	
	var response_code = result[1]
	var body: PackedByteArray = result[3]
	
	if response_code != 200:
		request_failed.emit("Server error: %d" % response_code)
		return null
	
	var json = JSON.new()
	if json.parse(body.get_string_from_utf8()) != OK:
		request_failed.emit("Couldn't parse response")
		return null
	
	return json.data

func build_query(params: Dictionary) -> String:
	var parts = []
	for key in params:
		var value = params[key]
		if value is Array:
			for item in value:
				parts.append("%s=%s" % [key, str(item)])
		else:
			parts.append("%s=%s" % [key, str(value)])
	return "&".join(parts)
