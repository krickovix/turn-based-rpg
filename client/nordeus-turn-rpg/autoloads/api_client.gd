extends Node

const SERVER_URL = "http://127.0.0.1:8000"

signal request_failed(reason: String)

func get_run_config() -> Variant:
	return await send_get("/run/new", {})

func get_monster_move(params: Dictionary) -> Variant:
	return await send_get("/battle/next-move", params)

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
