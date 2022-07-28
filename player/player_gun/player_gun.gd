extends Node2D


@onready var _player_sprite: Sprite2D = get_parent()


func _process(_delta: float) -> void:
	rotation = _player_sprite.get_local_mouse_position().angle() 
