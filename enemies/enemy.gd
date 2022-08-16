extends CharacterBody2D


const DeathEffect: PackedScene = preload("res://effects/enemy_death_effect/enemy_death_effect.tscn")

@export var max_speed: float = 15


@onready var stats: Node = $EnemyStats


func _on_hurtbox_hit(damage) -> void:
	stats.health -= damage


func _on_enemy_stats_enemy_died() -> void:
	Utils.instantiate_scene_on_main(DeathEffect, global_position)
	queue_free()
