class_name Move
extends RefCounted

static var static_id: int
var id: int
var string_id: String
var name: String
var effects: Array[Effect]
var description: String
var icon: Texture2D
var icon_big: Texture2D

func _init(str_id: String, n: String, desc: String) -> void:
	id = static_id
	static_id += 1
	string_id = str_id
	name = n
	description = desc
	icon = load("res://assets/sprites/moves/32x32/" + string_id + ".png")
	icon_big = load("res://assets/sprites/moves/64x64/" + string_id + ".png")
