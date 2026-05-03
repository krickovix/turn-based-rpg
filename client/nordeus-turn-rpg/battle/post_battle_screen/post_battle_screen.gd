extends Panel

const MAP_PATH = "res://map/map.tscn"

const END_STR = ["Victory!", "You died."]

@onready var header_label: Label = $LabelContainer/HeaderLabel
@onready var level_up_container: VBoxContainer = $LabelContainer/LevelUpContainer
@onready var level_up_label: Label = $LabelContainer/LevelUpContainer/LevelUpLabel
@onready var stat_gains_label: Label = $LabelContainer/LevelUpContainer/StatGainsLabel
@onready var learned_move_label: Label = $LabelContainer/LearnedMoveLabel
@onready var learned_move_card: MoveCard = $LabelContainer/LearnedMoveCard
@onready var back_button: Button = $LabelContainer/MarginContainer/BackButton


func _ready() -> void:
	visible = false
	level_up_container.visible = false
	learned_move_label.text = ""
	learned_move_card.visible = false

func _on_battle_battle_over(xp_gained: int, levels_gained: int, move_learned: Move) -> void:
	visible = true
	
	header_label.text = END_STR[0 if xp_gained else 1]
	
	if levels_gained > 0:
		level_up_container.visible = true
		level_up_label.text = "Level up! You are now level %d." % RunState.hero.level
		stat_gains_label.text = "+%d HP   +%d ATK   +%d DEF   +%d MAG" % [
			RunState.hero.HEALTH_GAIN, RunState.hero.ATTACK_GAIN, 
			RunState.hero.DEFENSE_GAIN, RunState.hero.MAGIC_GAIN
		]
	
	if move_learned:
		learned_move_label.text = "You learned:"
		learned_move_card.set_move(move_learned)
		learned_move_card.set_large()
		learned_move_card.visible = true
	elif xp_gained > 0:
		learned_move_label.text = "You already know all moves of this monster."

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file(MAP_PATH)
