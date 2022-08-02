extends Resource
class_name PlayerStats


signal player_died

var max_health := 4
var health := max_health:
	get:
		return health
	set(value):
		health = clamp(value, 0, max_health)
		if health == 0:
			player_died.emit()
