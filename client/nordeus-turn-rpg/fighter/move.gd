class_name Move
extends RefCounted

static var static_id: int
var id: int
var string_id: String
var name: String
var effects: Array[Effect]
var description: String

func _init() -> void:
	id = static_id
	static_id += 1
