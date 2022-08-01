extends Node


signal enemy_died

@export var max_health := 1

@onready var health := max_health:
	get:
		return health
	set(value):
		health = clampi(value, 0, max_health)
		if health == 0:
			enemy_died.emit()
