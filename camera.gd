extends Camera2D


var main_instances := LoadedResources.main_instances
var shake := 0.0

@onready var timer: Timer = $Timer


func _ready() -> void:
	Events.add_screen_shake.connect(self._screen_shake)
	main_instances.world_camera = self


func _process(_delta: float) -> void:
	if shake > 0:
		offset.x = randf_range(-shake, shake)
		offset.y = randf_range(-shake, shake)

func queue_free() -> void:
	super.queue_free()
	main_instances.world_camera = null


func _screen_shake(amount: float, duration: float) -> void:
	shake = amount
	timer.wait_time = duration
	timer.start()


func _on_timer_timeout() -> void:
	shake = 0
