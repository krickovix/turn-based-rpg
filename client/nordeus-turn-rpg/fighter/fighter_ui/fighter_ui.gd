extends Control

const PLAYER_TEXTURE = "res://assets/sprites/player.tres"
const MONSTER_TEXTURES: Array = [
	"res://assets/sprites/monsters/goblin_warrior.tres",
	"res://assets/sprites/monsters/goblin_mage.tres",
	"res://assets/sprites/monsters/giant_spider.tres",
	"res://assets/sprites/monsters/witch.tres",
	"res://assets/sprites/monsters/dragon.tres",
]

const STAT_ABBREV := {
	Effect.STAT.ATTACK: "ATK",
	Effect.STAT.DEFENSE: "DEF",
	Effect.STAT.MAGIC: "MAG",
	Effect.STAT.HEALTH: "HP",
}
 
const BUFF_COLOR := Color(0.4, 0.85, 0.4)  
const DEBUFF_COLOR := Color(0.9, 0.4, 0.4) 

@onready var name_label: Label = $StatsContainer/NameLabel
@onready var progress_bar: ProgressBar = $StatsContainer/ProgressBar
@onready var hp_label: Label = $StatsContainer/HPLabel
@onready var effects_container: VBoxContainer = $StatsContainer/EffectsContainer
@onready var fighter_texture: TextureRect = $FighterTexture

var fighter: Fighter


func bind(f: Fighter):
	if fighter:
		fighter.hp_changed.disconnect(_on_hp_changed)
	fighter = f
	name_label.text = f.name
	fighter.hp_changed.connect(_on_hp_changed)
	fighter.effects_changed.connect(_refresh_effects)
	_on_hp_changed(fighter.hp, fighter.max_hp)
	
	print(fighter.index)
	if fighter.index == -1:
		fighter_texture.texture = load(PLAYER_TEXTURE)
		fighter_texture.flip_h = true
	else:
		fighter_texture.texture = load(MONSTER_TEXTURES[fighter.index])

func _on_hp_changed(new_hp: int, max_hp: int) -> void:
	progress_bar.max_value = max_hp
	progress_bar.value = new_hp
	hp_label.text = "%d / %d" % [new_hp, max_hp]
	
func _refresh_effects() -> void:
	for child in effects_container.get_children():
		child.queue_free()
 
	if fighter == null:
		return
		
	for effect in fighter.active_effects:
		var label := Label.new()
		label.text = _format_effect(effect)
		label.add_theme_color_override("font_color",
			BUFF_COLOR if effect.type == Effect.TYPE.BUFF else DEBUFF_COLOR)
		label.add_theme_font_size_override("font_size", 28)
		effects_container.add_child(label)
		
func _format_effect(effect: Effect) -> String:
	var sign_str := "+" if effect.type == Effect.TYPE.BUFF else "-"
	var stat_str: String = STAT_ABBREV[effect.stat]
	var turns_word := "turn" if effect.turns_remaining == 1 else "turns"
	return "%s%d %s (%d %s)" % [sign_str, effect.base_value, stat_str, effect.turns_remaining, turns_word]
