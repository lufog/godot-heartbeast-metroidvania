extends Node2D


func _ready() -> void:
	SoundFx.play("explosion", -10, randf_range(0.6, 1.0))
