extends Powerup


func _pickup() -> void:
	player_stats.missles_unlocked = true
	queue_free()
