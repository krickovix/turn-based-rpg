class_name ConfirmPopUp
extends CenterContainer

signal clicked_confirm
signal clicked_cancel

@onready var label: Label = $MarginContainer/VBoxContainer/Label
@onready var ok_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/OkButton
@onready var cancel_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/CancelButton


func set_text(text: String) -> void:
	label.text = text

func _on_ok_button_pressed() -> void:
	clicked_confirm.emit()

func _on_cancel_button_pressed() -> void:
	clicked_cancel.emit()
	hide()
