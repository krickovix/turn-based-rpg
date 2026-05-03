class_name StartBattleButton
extends CenterContainer

signal start_button_pressed

const MONSTER_TEXTURES: Array[String] = [
	"res://assets/sprites/monsters/goblin_warrior.png",
	"res://assets/sprites/monsters/goblin_mage.png",
	"res://assets/sprites/monsters/giant_spider.png",
	"res://assets/sprites/monsters/witch.png",
	"res://assets/sprites/monsters/dragon.png"
	
]

@onready var icon_button: IconButton = $CenterContainer/VBoxContainer/IconButton
@onready var lock_icon: TextureRect = $LockIcon

var monster: Fighter


func bind_fighter(index: int):
	monster = RunState.monsters[index]
	icon_button.set_icon(monster.name, MONSTER_TEXTURES[index])
	icon_button.set_shadow()
	
func unlock():
	lock_icon.visible = false
	icon_button.disabled = false
	icon_button.modulate = Color.WHITE
	lock_icon.hide()
	
func lock():
	lock_icon.visible = true
	icon_button.disabled = true
	icon_button.modulate = Color.DIM_GRAY
	lock_icon.show()

func _on_icon_button_pressed() -> void:
	start_button_pressed.emit()
