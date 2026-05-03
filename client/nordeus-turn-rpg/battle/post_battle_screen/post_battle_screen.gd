extends CanvasLayer

const MAP_PATH = "res://map/map.tscn"

const END_STR = ["Victory!", "You died."]
const STAT_TEXTURES: Dictionary = {
	Effect.STAT.HEALTH: "res://assets/icons/stats/health.png",
	Effect.STAT.ATTACK: "res://assets/icons/stats/attack.png",
	Effect.STAT.DEFENSE: "res://assets/icons/stats/defense.png",
	Effect.STAT.MAGIC: "res://assets/icons/stats/magic.png"
}

@onready var header_label: Label = $LabelContainer/HeaderLabel
@onready var level_up_container: VBoxContainer = $LabelContainer/LevelUpContainer
@onready var level_up_label: Label = $LabelContainer/LevelUpContainer/LevelUpLabel
@onready var stat_gains_label: RichTextLabel = $LabelContainer/LevelUpContainer/StatGainsLabel
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
		stat_gains_label.bbcode_enabled = true
		stat_gains_label.text = "+%d [img=24]%s[/img] HP   +%d [img=24]%s[/img] ATK   +%d [img=24]%s[/img] DEF   +%d [img=24]%s[/img] MAG" % [
			RunState.hero.HEALTH_GAIN, STAT_TEXTURES[Effect.STAT.HEALTH],
			RunState.hero.ATTACK_GAIN, STAT_TEXTURES[Effect.STAT.ATTACK],
			RunState.hero.DEFENSE_GAIN, STAT_TEXTURES[Effect.STAT.DEFENSE],
			RunState.hero.MAGIC_GAIN, STAT_TEXTURES[Effect.STAT.MAGIC],
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
