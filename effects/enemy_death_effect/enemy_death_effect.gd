extends Node2D


func _on_dust_effect_last_tree_exited() -> void:
	queue_free()
