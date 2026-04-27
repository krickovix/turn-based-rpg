extends Node2D

const BATTLE_PATH = "res://battle/battle.tscn"
	
func _ready() -> void:
	print("Map opened, run config: ", GameState.run_config)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(BATTLE_PATH)
	
	
