extends Control

const BATTLE_PATH = "res://battle/battle.tscn"
const MENU_PATH = "res://main_menu/main_menu.tscn"
const MOVESET_MANAGER_PATH = "res://moveset_manager/moveset_manager.tscn"
const MENU_STR = "Menu"
const MENU_TEXTURE = "res://assets/icons/book_2_icon.tres"

@onready var run_complete_label: Label = $MarginContainer/VBoxContainer/HeaderContainer/RunCompleteLabel
@onready var complete_label: TypedTextLabel = $MarginContainer/VBoxContainer/HeaderContainer/CompleteLabel
@onready var confirm_back_dialog: ConfirmationDialog = $MarginContainer/VBoxContainer/ConfirmBackDialog
@onready var start_battle_buttons: Array[StartBattleButton] = [
	$MarginContainer/VBoxContainer/StartButtonsContainer/StartBattleButton, 
	$MarginContainer/VBoxContainer/StartButtonsContainer/StartBattleButton2, 
	$MarginContainer/VBoxContainer/StartButtonsContainer/StartBattleButton3, 
	$MarginContainer/VBoxContainer/StartButtonsContainer/StartBattleButton4, 
	$MarginContainer/VBoxContainer/StartButtonsContainer/StartBattleButton5
]
@onready var confirm_pop_up: ConfirmPopUp = $ConfirmPopUp
@onready var back_icon_button: IconButton = $MarginContainer/VBoxContainer/HeaderContainer/HBoxContainer/BackIconButton


func _ready() -> void:
	if RunState.max_encounter_index >= 5:
		complete_label.type_text("Congratulations!\nMission completed.")
	
	for i in range(RunState.monsters.size()):
		var start_battle_button: StartBattleButton = start_battle_buttons[i]
		start_battle_button.bind_fighter(i)
		
		start_battle_button.start_button_pressed.connect(_on_encounter_pressed.bind(i))
		if i <= RunState.max_encounter_index:
			start_battle_button.unlock()
		else:
			start_battle_button.lock()
			
	confirm_pop_up.hide()
	confirm_pop_up.set_text("Are you sure you want to exit? All progress will be lost...")
	confirm_pop_up.clicked_confirm.connect(_on_popup_clicked_confirm)
	back_icon_button.set_icon(MENU_STR, MENU_TEXTURE)

func _on_encounter_pressed(index: int) -> void:
	print(index)
	RunState.current_encounter_index = index
	get_tree().change_scene_to_file(BATTLE_PATH)

func _on_popup_clicked_confirm() -> void:
	get_tree().change_scene_to_file(MENU_PATH)

func _on_icon_button_pressed() -> void:
	get_tree().change_scene_to_file(MOVESET_MANAGER_PATH)

func _on_back_icon_button_pressed() -> void:
	if RunState.max_encounter_index < 5:
		confirm_pop_up.show()
		return
	
	get_tree().change_scene_to_file(MENU_PATH)
