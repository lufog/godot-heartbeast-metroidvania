extends Node2D
class_name Projectile


var velocity := Vector2.ZERO 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta


func _on_visible_notifier_screen_exited() -> void:
	queue_free()
