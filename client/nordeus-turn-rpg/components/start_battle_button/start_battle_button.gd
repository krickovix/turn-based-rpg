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

@onready var button: Button = $CenterContainer/VBoxContainer/Button
@onready var fighter_icon: FighterIcon = $CenterContainer/VBoxContainer/Button/FighterIcon
@onready var name_label: Label = $CenterContainer/VBoxContainer/NameLabel
@onready var lock_icon: TextureRect = $LockIcon

var monster: Fighter


func bind_fighter(index: int):
	monster = RunState.monsters[index]
	fighter_icon.set_texture(load(MONSTER_TEXTURES[index]))
	name_label.text = monster.name
	
func unlock():
	lock_icon.visible = false
	button.disabled = false
	fighter_icon.unlock()
	
func lock():
	lock_icon.visible = true
	button.disabled = true
	fighter_icon.lock()

func _on_button_pressed() -> void:
	start_button_pressed.emit()
