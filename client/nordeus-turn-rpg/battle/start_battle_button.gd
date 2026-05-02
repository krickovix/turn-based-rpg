class_name StartBattleButton
extends CenterContainer

signal start_button_pressed

const MONSTER_TEXTURES: Array[String] = [
	"res://assets/sprites/monsters/goblin_warrior.tres",
	"res://assets/sprites/monsters/goblin_mage.tres",
	"res://assets/sprites/monsters/giant_spider.tres",
	"res://assets/sprites/monsters/witch.tres",
	"res://assets/sprites/monsters/dragon.tres"
	
]

@onready var button: Button = $VBoxContainer/Button
@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var locked_icon: TextureRect = $LockedIcon

var monster: Fighter


func bind_fighter(index: int):
	monster = RunState.monsters[index]
	button.icon = load(MONSTER_TEXTURES[index])
	print(button.icon)
	name_label.text = monster.name
	
func unlock():
	locked_icon.visible = false
	button.disabled = false
	
func lock():
	locked_icon.visible = true
	button.disabled = true

func _on_button_pressed() -> void:
	print("HERE")
	start_button_pressed.emit()
