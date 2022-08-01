extends CharacterBody2D


@export var max_speed: float = 15


@onready var stats: Node = $EnemyStats


func _on_hurtbox_hit(damage) -> void:
	stats.health -= damage


func _on_enemy_stats_enemy_died() -> void:
	queue_free()
