extends Control

const BATTLE_PATH = "res://battle/battle.tscn"
const MENU_PATH = "res://main_menu/main_menu.tscn"

@onready var start_battle_buttons : Array[Button] = [
	$StartButtons/Button0, 
	$StartButtons/Button1, 
	$StartButtons/Button2, 
	$StartButtons/Button3, 
	$StartButtons/Button4
]

@onready var run_complete_label: Label = $RunCompleteLabel
@onready var confirm_back_dialog: ConfirmationDialog = $ConfirmBackDialog


func _ready() -> void:
	var run_done = RunState.max_encounter_index >= 5
	run_complete_label.visible = run_done
	
	for i in range(RunState.monsters.size()):
		var button: Button = start_battle_buttons[i]
		var monster_name = RunState.monsters[i].name
		
		button.pressed.connect(_on_encounter_pressed.bind(i))
		if i < RunState.max_encounter_index:
			button.text = "✓ %s" % monster_name
			button.disabled = false
		elif i == RunState.max_encounter_index:
			button.text = "▶ %s" % monster_name
		else:
			button.text = "🔒 %s" % monster_name
			button.disabled = true
		

func _on_encounter_pressed(index: int) -> void:
	RunState.current_encounter_index = index
	get_tree().change_scene_to_file(BATTLE_PATH)


func _on_back_button_pressed() -> void:
	if RunState.max_encounter_index < 5:
		confirm_back_dialog.visible = true
		return
	
	get_tree().change_scene_to_file(MENU_PATH)


func _on_confirmation_dialog_confirmed() -> void:
	get_tree().change_scene_to_file(MENU_PATH)
