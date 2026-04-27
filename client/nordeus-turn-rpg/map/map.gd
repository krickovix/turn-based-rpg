extends Control

const BATTLE_PATH = "res://battle/battle.tscn"

@onready var start_battle_buttons : Array[Button] = [
	$StartButtons/Button0, 
	$StartButtons/Button1, 
	$StartButtons/Button2, 
	$StartButtons/Button3, 
	$StartButtons/Button4
]


func _ready() -> void:
	var encounters = GameState.run_config["encounters"]
	for i in range(encounters.size()):
		var button: Button = start_battle_buttons[i]
		button.text = "Fight " + str(i+1) + " : " + encounters[i]["name"]
		button.pressed.connect(_on_encounter_pressed.bind(i))
		

func _on_encounter_pressed(index: int) -> void:
	GameState.current_encounter = GameState.run_config["encounters"][index]
	get_tree().change_scene_to_file(BATTLE_PATH)
	
	
