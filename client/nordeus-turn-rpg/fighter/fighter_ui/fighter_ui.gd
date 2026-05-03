extends Control

const FLOATING_TEXT_LABEL = preload("res://components/floating_text_label/floating_text_label.tscn")
const PLAYER_TEXTURE = "res://assets/sprites/player.tres"
const MONSTER_TEXTURES: Array = [
	"res://assets/sprites/monsters/goblin_warrior.png",
	"res://assets/sprites/monsters/goblin_mage.png",
	"res://assets/sprites/monsters/giant_spider.png",
	"res://assets/sprites/monsters/witch.png",
	"res://assets/sprites/monsters/dragon.png",
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
	
func _refresh_effects(new_effect: Effect) -> void:
	if fighter == null:
		return
		
	if new_effect and new_effect.turns_remaining <= 0:
		play_effect_animation(new_effect)
		return
	
	for effect in fighter.active_effects:
		var stat = int(stat_labels[effect.stat].text)
		stat += effect.base_value
		stat_labels[effect.stat].text = str(stat)
		
		play_effect_animation(effect)
		show_floating_effect(effect)

const TYPE_COLORS := {
	Effect.TYPE.DAMAGE: "ff5555",
	Effect.TYPE.HEAL: "55ff77",
	Effect.TYPE.BUFF: "66dd66",
	Effect.TYPE.DEBUFF: "ee6666",
}

const STAT_COLORS := {
	Effect.STAT.ATTACK: Color(1.0, 0.6, 0.4),
	Effect.STAT.DEFENSE: Color(0.5, 0.7, 1.0),
	Effect.STAT.MAGIC: Color(0.8, 0.5, 1.0),  
	Effect.STAT.HEALTH: Color(0.4, 1.0, 0.5), 
}

func play_effect_animation(effect: Effect):
	match effect.type:
		Effect.TYPE.DAMAGE:
			play_hit_animation()
			flash_color(STAT_COLORS[effect.stat], 0.25)
		Effect.TYPE.HEAL:
			play_heal_animation()
		Effect.TYPE.BUFF:
			play_buff_animation(STAT_COLORS.get(effect.stat, Color.WHITE))
		Effect.TYPE.DEBUFF:
			play_debuff_animation(STAT_COLORS.get(effect.stat, Color.WHITE))
			
func play_heal_animation() -> void:
	var tween := create_tween().set_parallel(true)
	tween.tween_property(self, "modulate", Color(0.6, 1.5, 0.7), 0.2)  # bright green
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.2).set_trans(Tween.TRANS_QUAD)
	tween.chain().set_parallel(true)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.3)
	
func play_buff_animation(stat_color: Color) -> void:
	var tween := create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1.15, 1.15), 0.2).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "modulate", stat_color, 0.2)
	tween.chain().set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.2)
	tween.tween_property(self, "modulate", Color.WHITE, 0.2)
	
func play_debuff_animation(stat_color: Color) -> void:
	var tween := create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector2(0.9, 0.9), 0.2).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "modulate", stat_color.darkened(0.3), 0.2)
	tween.chain().set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.25)
	tween.tween_property(self, "modulate", Color.WHITE, 0.25)
	
func flash_color(color: Color, duration: float = 0.2) -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate", color, duration / 2)
	tween.tween_property(self, "modulate", Color.WHITE, duration / 2)
	
func play_hit_animation() -> void:
	var original_pos := position
	var tween := create_tween()
	for i in 4:
		tween.tween_property(self, "position", original_pos + Vector2(randf_range(-4, 4), 0), 0.04)
	tween.tween_property(self, "position", original_pos, 0.04)
	
func play_attack_animation(direction: Vector2) -> void:
	var original_pos := position
	var tween := create_tween()
	tween.tween_property(self, "position", original_pos + direction * 30, 0.1)
	tween.tween_property(self, "position", original_pos, 0.15)

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
