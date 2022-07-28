extends CharacterBody2D

const DUST_EFFECT_SCENE: PackedScene = preload("res://effects/dust_effect/dust_effect.tscn")

@export var max_speed: float = 64
@export var acceleration: float = 256
@export var friction: float = 0.25
@export var jump_force: float = 128
@export var max_slope_angle: float = 46

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping: bool = false

@onready var sprite: Sprite2D = $Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var coyote_timer: Timer = $CoyoteTimer


func _physics_process(delta: float) -> void:
	var facing_direction: int = sign(get_local_mouse_position().x)
	sprite.scale.x = facing_direction
	
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		if direction == facing_direction:
			animation_player.play("run")
		else:
			animation_player.play_backwards("run")
		
		velocity.x += direction * acceleration * delta
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
	else:
		animation_player.play("idle")
		velocity.x = lerp(velocity.x, 0, friction)
	
	if is_on_floor():
		is_jumping = false
	else:
		# Apply gravity.
		velocity.y += gravity * delta
		velocity.y = clamp(velocity.y, -jump_force, jump_force)

		animation_player.play("jump")
		if Input.is_action_just_released("jump") and velocity.y < -jump_force / 2:
			velocity.y = -jump_force / 2
	
	if is_on_floor() or not coyote_timer.is_stopped():
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jump_force
			is_jumping = true
			coyote_timer.stop()
	
	var was_on_flor = is_on_floor()

	move_and_slide()

	if was_on_flor and not is_on_floor() and not is_jumping:
		coyote_timer.start()
	
	if not was_on_flor and is_on_floor():
		_create_dust_effect()


func _create_dust_effect() -> void:
	var dust_effect := DUST_EFFECT_SCENE.instantiate() as Node2D
	get_parent().add_child(dust_effect)
	dust_effect.global_position = global_position + Vector2(randf_range(-4, 4), 0)
