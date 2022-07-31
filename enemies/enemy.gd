extends CharacterBody2D


@export var max_speed: float = 15


func _on_hurtbox_hit(_damage) -> void:
	queue_free()
