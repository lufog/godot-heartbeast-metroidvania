extends Node2D


var velocity := Vector2(randf_range(-20, 20), randf_range(-10, -40))


func _process(delta: float) -> void:
	position += velocity * delta
