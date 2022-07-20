extends CharacterBody2D


@export var acceleration: int = 256
@export var max_speed: int = 64
@export var friction: float = 0.25


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity += direction * acceleration * delta
		velocity = velocity.limit_length(max_speed)
	else:
		velocity = velocity.slerp(Vector2.ZERO, friction)

	move_and_slide()
