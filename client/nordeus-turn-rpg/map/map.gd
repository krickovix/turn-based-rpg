extends Control

const BATTLE_PATH = "res://battle/battle.tscn"
const MENU_PATH = "res://main_menu/main_menu.tscn"
const MOVESET_MANAGER_PATH = "res://moveset_manager/moveset_manager.tscn"

@onready var run_complete_label: Label = $MarginContainer/HeaderContainer/RunCompleteLabel
@onready var confirm_back_dialog: ConfirmationDialog = $MarginContainer/ConfirmBackDialog
@onready var start_battle_buttons: Array[StartBattleButton] = [
	$MarginContainer/StartButtonsContainer/StartBattleButton, 
	$MarginContainer/StartButtonsContainer/StartBattleButton2, 
	$MarginContainer/StartButtonsContainer/StartBattleButton3, 
	$MarginContainer/StartButtonsContainer/StartBattleButton4, 
	$MarginContainer/StartButtonsContainer/StartBattleButton5
]


func _ready() -> void:
	var run_done = RunState.max_encounter_index >= 5
	run_complete_label.visible = run_done
	
	for i in range(RunState.monsters.size()):
		var start_battle_button: StartBattleButton = start_battle_buttons[i]
		start_battle_button.bind_fighter(i)
		
		start_battle_button.start_button_pressed.connect(_on_encounter_pressed.bind(i))
		if i < RunState.max_encounter_index:
			start_battle_button.unlock()
		else:
			start_battle_button.lock()
		

func _on_encounter_pressed(index: int) -> void:
	print(index)
	RunState.current_encounter_index = index
	get_tree().change_scene_to_file(BATTLE_PATH)


func _on_back_button_pressed() -> void:
	if RunState.max_encounter_index < 5:
		confirm_back_dialog.visible = true
		return
	
	get_tree().change_scene_to_file(MENU_PATH)


func _on_confirmation_dialog_confirmed() -> void:
	get_tree().change_scene_to_file(MENU_PATH)
	

func _on_move_management_button_pressed() -> void:
	get_tree().change_scene_to_file(MOVESET_MANAGER_PATH)
