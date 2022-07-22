extends CharacterBody2D


@export var max_speed: float = 64
@export var acceleration: float = 256
@export var friction: float = 0.25
@export var jump_force: float = 128
@export var max_slope_angle: float = 46

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite: Sprite2D = $Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		sprite.flip_h = direction < 0
		animation_player.play("run")
		velocity.x += direction * acceleration * delta
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
	else:
		animation_player.play("idle")
		velocity.x = lerp(velocity.x, 0, friction)
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = -jump_force
	else:
		# Apply gravity.
		velocity.y += gravity * delta
		velocity.y = clamp(velocity.y, -jump_force, jump_force)
		
		animation_player.play("jump")
		if Input.is_action_just_released("ui_up") and velocity.y < -jump_force / 2:
			velocity.y = -jump_force / 2
	
	move_and_slide()
