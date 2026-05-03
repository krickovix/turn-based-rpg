extends Control

const FLOATING_TEXT_LABEL = preload("res://components/floating_text_label/floating_text_label.tscn")
const PLAYER_TEXTURE = "res://assets/sprites/player.tres"
const MONSTER_TEXTURES: Array = [
	"res://assets/sprites/monsters/goblin_warrior.tres",
	"res://assets/sprites/monsters/goblin_mage.tres",
	"res://assets/sprites/monsters/giant_spider.tres",
	"res://assets/sprites/monsters/witch.tres",
	"res://assets/sprites/monsters/dragon.tres",
]
const STAT_TEXTURES: Dictionary = {
	Effect.STAT.ATTACK: "res://assets/icons/stats/attack.png",
	Effect.STAT.DEFENSE: "res://assets/icons/stats/defense.png",
	Effect.STAT.MAGIC: "res://assets/icons/stats/magic.png"
}

@onready var name_label: Label = $StatsContainer/NameLabel
@onready var progress_bar: ProgressBar = $StatsContainer/HPContainer/ProgressBar
@onready var hp_label: Label = $StatsContainer/HPContainer/HPLabel
@onready var effects_container: VBoxContainer = $StatsContainer/EffectsContainer
@onready var attack_label: Label = $StatsContainer/Stats/AttackContainer/Label
@onready var defense_label: Label = $StatsContainer/Stats/DefenseContainer/Label
@onready var magic_label: Label = $StatsContainer/Stats/MagicContainer/Label
@onready var fighter_icon: FighterIcon = $FighterIcon

@onready var stat_labels: Dictionary = {
	Effect.STAT.ATTACK: attack_label,
	Effect.STAT.DEFENSE: defense_label,
	Effect.STAT.MAGIC: magic_label
}

var fighter: Fighter


func bind(f: Fighter):
	if fighter:
		fighter.hp_changed.disconnect(_on_hp_changed)
	fighter = f
	name_label.text = f.name
	fighter.hp_changed.connect(_on_hp_changed)
	fighter.effects_changed.connect(_refresh_effects)
	_on_hp_changed(fighter.hp, fighter.max_hp)
	
	if fighter.index == -1:
		fighter_icon.set_texture(load(PLAYER_TEXTURE))
		fighter_icon.flip_h()
	else:
		fighter_icon.set_texture(load(MONSTER_TEXTURES[fighter.index]))
	fighter_icon.set_large()

func _on_hp_changed(new_hp: int, max_hp: int) -> void:
	progress_bar.max_value = max_hp
	progress_bar.value = new_hp
	hp_label.text = "%d / %d" % [new_hp, max_hp]
	attack_label.text = str(fighter.attack)
	defense_label.text = str(fighter.defense)
	magic_label.text = str(fighter.magic)
	
func _refresh_effects() -> void:
	if fighter == null:
		return
	
	for effect in fighter.active_effects:
		var stat = int(stat_labels[effect.stat].text)
		stat += effect.base_value
		stat_labels[effect.stat].text = str(stat)
		
		show_floating_effect(effect)

const TYPE_COLORS := {
	Effect.TYPE.DAMAGE: "ff5555",
	Effect.TYPE.HEAL: "55ff77",
	Effect.TYPE.BUFF: "66dd66",
	Effect.TYPE.DEBUFF: "ee6666",
}

func show_floating_effect(effect: Effect) -> void:
	var bbcode := _build_floating_bbcode(effect)
	
	var spawn_pos := fighter_icon.global_position# + Vector2(fighter_icon.size.x / 2 - 30, -10)
	
	var floater := FLOATING_TEXT_LABEL.instantiate()
	get_tree().root.add_child(floater)
	floater.show_text(bbcode, spawn_pos)

func _build_floating_bbcode(effect: Effect) -> String:
	var color: String = TYPE_COLORS.get(effect.type, "ffffff")
	var icon_path: String = STAT_TEXTURES[effect.stat]
	var icon_tag := "[img=24]%s[/img] " % icon_path if icon_path else ""
	
	var sign_str := ""
	match effect.type:
		Effect.TYPE.DAMAGE: sign_str = "-"
		Effect.TYPE.HEAL: sign_str = "+"
		Effect.TYPE.BUFF: sign_str = "+"
		Effect.TYPE.DEBUFF: sign_str = "-"
	
	return "[color=#%s]%s%s%d[/color]" % [color, icon_tag, sign_str, effect.base_value]
