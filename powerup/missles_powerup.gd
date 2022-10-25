extends Powerup


func _pickup() -> void:
	super()
	player_stats.missles_unlocked = true
	queue_free()
