extends Projectile


const BRICK_LAYER_BIT := 5

const EnemyDeathEffect: PackedScene = preload("res://effects/enemy_death_effect/enemy_death_effect.tscn")


func _ready() -> void:
	SoundFx.play("explosion", -10)


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is StaticBody2D and body.get_collision_layer_value(BRICK_LAYER_BIT):
		body.queue_free()
		Utils.instantiate_scene_on_main(EnemyDeathEffect, global_position + Vector2(8, 8))
	super._on_hitbox_body_entered(body)
