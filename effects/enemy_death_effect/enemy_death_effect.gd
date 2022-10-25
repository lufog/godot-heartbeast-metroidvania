extends Node2D


func _ready() -> void:
	SoundFx.play("enemy_die", -10)


func _on_dust_effect_last_tree_exited() -> void:
	queue_free()
