extends Control


const SPRITE_PATHS: Array[String] = []

@onready var name_label: Label = $StatsContainer/NameLabel
@onready var progress_bar: ProgressBar = $StatsContainer/ProgressBar
@onready var hp_label: Label = $StatsContainer/HPLabel
@onready var texture_rect: TextureRect = $StatsContainer/TextureRect

var fighter: Fighter

func bind(f: Fighter):
	if fighter:
		fighter.hp_changed.disconnect(on_hp_changed)
	fighter = f
	name_label.text = f.name
	fighter.hp_changed.connect(on_hp_changed)
	on_hp_changed(fighter.hp, fighter.max_hp)


func on_hp_changed(new_hp: int, max_hp: int) -> void:
	progress_bar.max_value = max_hp
	progress_bar.value = new_hp
	hp_label.text = "%d / %d" % [new_hp, max_hp]
