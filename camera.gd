extends Camera2D


var shake: float = 0

@onready var timer: Timer = $Timer


func _ready() -> void:
	Events.add_screen_shake.connect(self._screen_shake)


func _process(_delta: float) -> void:
	if shake > 0:
		offset.x = randf_range(-shake, shake)
		offset.y = randf_range(-shake, shake)


func _screen_shake(amount: float, duration: float) -> void:
	shake = amount
	timer.wait_time = duration
	timer.start()


func _on_timer_timeout() -> void:
	shake = 0
