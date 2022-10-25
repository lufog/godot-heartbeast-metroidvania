extends Projectile


func _ready() -> void:
	set_process(false)
	SoundFx.play("bullet", -10.0, randf_range(0.8, 1.1))
