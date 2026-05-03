class_name MoveTooltip
extends PanelContainer

const TOOLTIP_EFFECT_ROW = preload("uid://bsqe3iv6smq5o")
const FADE_DURATION := 0.15

@onready var name_label: Label = $MarginContainer/VBoxContainer2/NameLabel
@onready var description_label: Label = $MarginContainer/VBoxContainer2/DescriptionLabel
@onready var effects_container: VBoxContainer = $MarginContainer/VBoxContainer2/EffectsContainer

var _fade_tween: Tween


func _ready() -> void:
	modulate.a = 0.0  

func fade_in() -> void:
	if _fade_tween:
		_fade_tween.kill()
	_fade_tween = create_tween()
	_fade_tween.tween_property(self, "modulate:a", 1.0, FADE_DURATION)

func fade_out_and_free() -> void:
	if _fade_tween:
		_fade_tween.kill()
	_fade_tween = create_tween()
	_fade_tween.tween_property(self, "modulate:a", 0.0, FADE_DURATION)
	_fade_tween.tween_callback(queue_free)

func populate(move: Move) -> void:
	name_label.text = move.name
	description_label.text = move.description
	
	for child in effects_container.get_children():
		child.queue_free()
	
	for effect in move.effects:
		var row := TOOLTIP_EFFECT_ROW.instantiate()
		effects_container.add_child(row)
		row.populate(effect)
