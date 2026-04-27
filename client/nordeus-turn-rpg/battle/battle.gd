extends Node2D

const MAP_PATH = "res://map/map.tscn"


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(MAP_PATH)
