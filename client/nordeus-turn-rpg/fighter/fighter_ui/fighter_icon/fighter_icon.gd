class_name FighterIcon
extends Control

@onready var icon_shadow: TextureRect = $IconShadow
@onready var icon: TextureRect = $Icon
@onready var icon_locked: TextureRect = $IconLocked

var texture: Texture2D


func set_texture(t: Texture2D):
	texture = t
	icon.texture = texture
	icon_locked.texture = texture
	icon_shadow.texture = texture
	
func lock() -> void:
	icon_locked.visible = true
	
func unlock() -> void:
	icon_locked.visible = false
	
func flip_h():
	icon.flip_h = true
	icon_locked.flip_h = true
	icon_shadow.flip_h = true
	
func set_large():
	custom_minimum_size *= 1.2
	
	
	
