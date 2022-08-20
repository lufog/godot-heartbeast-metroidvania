extends Resource
class_name PlayerStats


signal player_died
signal player_health_changed(value: int)
signal player_missles_changed(value: int)

var max_health := 4
var health := max_health:
	get:
		return health
	set(value):
		health = clamp(value, 0, max_health)
		player_health_changed.emit(health)
		if health == 0:
			player_died.emit()

var max_missles := 3
var missles := max_missles:
	get:
		return missles
	set(value):
		missles = clamp(value, 0, max_missles)
		player_missles_changed.emit(missles)
