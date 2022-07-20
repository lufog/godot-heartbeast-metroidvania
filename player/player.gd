extends CharacterBody2D


@export var max_speed: float = 64
@export var acceleration: float = 256
@export var friction: float = 0.25
@export var jump_force: float = 128
@export var max_slope_angle: float = 46

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x += direction * acceleration * delta
		velocity.x = min(velocity.x, direction * max_speed)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = -jump_force
	else:
		# Apply gravity.
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, jump_force)
		
		if Input.is_action_just_released("ui_up") and velocity.y < -jump_force / 2:
			velocity.y = -jump_force / 2
	
	print(velocity)
	
	move_and_slide()
