class_name TooltipEffectRow
extends HBoxContainer

const STAT_ICONS := {
	Effect.STAT.ATTACK: "res://assets/icons/stats/attack.png",
	Effect.STAT.DEFENSE: "res://assets/icons/stats/defense.png",
	Effect.STAT.MAGIC: "res://assets/icons/stats/magic.png",
	Effect.STAT.HEALTH: "res://assets/icons/stats/health.png",
}
const ICON_SIZE := 20

@onready var value_label: RichTextLabel = $ValueLabel


func populate(effect: Effect) -> void:
	value_label.bbcode_enabled = true
	value_label.text = _format_effect_text(effect)

func _format_effect_text(effect: Effect) -> String:
	match effect.type:
		Effect.TYPE.DAMAGE:
			return _format_damage(effect)
		Effect.TYPE.HEAL:
			return _format_heal(effect)
		Effect.TYPE.BUFF:
			return _format_buff(effect)
		Effect.TYPE.DEBUFF:
			return _format_debuff(effect)
	return ""

func _format_damage(effect: Effect) -> String:
	if effect.stat == Effect.STAT.MAGIC:
		return "Damage: %d + self %s MAG" % [
			effect.base_value, _icon(STAT_ICONS[Effect.STAT.MAGIC])
		]
	else:
		return "Damage: %d + self %s ATK - enemy %s DEF" % [
			effect.base_value, _icon(STAT_ICONS[Effect.STAT.ATTACK]), _icon(STAT_ICONS[Effect.STAT.DEFENSE])
		]

func _format_heal(effect: Effect) -> String:
	return "Heal: %d + self %s MAG" % [effect.base_value, _icon(STAT_ICONS[Effect.STAT.MAGIC])]

func _format_buff(effect: Effect) -> String:
	return "+" + _format_buffs(effect)
	
func _format_debuff(effect: Effect) -> String:
	return "-" + _format_buffs(effect)

func _format_buffs(effect: Effect) -> String:
	var stat_str := _stat_name(effect.stat)
	var turns := _turns_text(effect.turns_remaining)
	return "%d %s %s for %s" % [effect.base_value, _icon(STAT_ICONS[effect.stat]), stat_str, turns]

func _icon(path: String) -> String:
	return "[img=%d]%s[/img]" % [ICON_SIZE, path]

func _stat_name(stat: Effect.STAT) -> String:
	match stat:
		Effect.STAT.ATTACK: return "ATK"
		Effect.STAT.DEFENSE: return "DEF"
		Effect.STAT.MAGIC: return "MAG"
		Effect.STAT.HEALTH: return "HP"
	return ""

func _turns_text(turns: int) -> String:
	if turns == 1: return "1 turn"
	return "%d turns" % turns
