extends CharacterBody2D

const DUST_EFFECT_SCENE: PackedScene = preload("res://effects/dust_effect/dust_effect.tscn")
const JUMP_EFFECT_SCENE: PackedScene =preload("res://effects/jump_effect/jump_effect.tscn")
const BULLET_SCENE: PackedScene = preload("res://player/projectile/player_bullet.tscn")

var stats = LoadedResources.player_stats

@export var max_speed: float = 64
@export var acceleration: float = 256
@export var friction: float = 0.25
@export var jump_force: float = 128
@export var max_slope_angle: float = 46
@export var bullet_speed: float = 250
@export var invincible := false

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping: bool = false

@onready var sprite: Sprite2D = $Sprite
@onready var gun: Node2D = $Sprite/PlayerGun
@onready var muzzle_location: Node2D = $Sprite/PlayerGun/Sprite/MuzzleLocation
@onready var sprite_animation_player: AnimationPlayer = $SpriteAnimationPlayer
@onready var blink_animation_player: AnimationPlayer = $BlinkAnimationPlayer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var fire_bullet_timer: Timer = $FireBulletTimer


func _ready() -> void:
	stats.player_died.connect(self._on_died)


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("fire") and fire_bullet_timer.is_stopped():
		_fire_bullet()
	
	var facing_direction: int = sign(get_local_mouse_position().x)
	sprite.scale.x = facing_direction
	
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		if direction == facing_direction:
			sprite_animation_player.play("run")
		else:
			sprite_animation_player.play_backwards("run")
		
		velocity.x += direction * acceleration * delta
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
	else:
		sprite_animation_player.play("idle")
		velocity.x = lerp(velocity.x, 0, friction)
	
	if is_on_floor():
		is_jumping = false
	else:
		# Apply gravity.
		velocity.y += gravity * delta
		velocity.y = clamp(velocity.y, -jump_force, jump_force)

		sprite_animation_player.play("jump")
		if Input.is_action_just_released("jump") and velocity.y < -jump_force / 2:
			velocity.y = -jump_force / 2
	
	if is_on_floor() or not coyote_timer.is_stopped():
		if Input.is_action_just_pressed("jump"):
			Utils.instantiate_scene_on_main(JUMP_EFFECT_SCENE, global_position)
			velocity.y = -jump_force
			is_jumping = true
			coyote_timer.stop()
	
	var was_on_flor = is_on_floor()

	move_and_slide()

	if was_on_flor and not is_on_floor() and not is_jumping:
		coyote_timer.start()
	
	if not was_on_flor and is_on_floor():
		Utils.instantiate_scene_on_main(JUMP_EFFECT_SCENE, global_position)


func _on_hurtbox_hit(damage) -> void:
	if not invincible:
		Events.add_screen_shake.emit(0.4, 0.5)
		stats.health -= damage
		blink_animation_player.play("blink")


func _on_died() -> void:
	queue_free()


func _create_dust_effect() -> void:
	var dust_position := global_position + Vector2(randf_range(-4, 4), 0)
	Utils.instantiate_scene_on_main(DUST_EFFECT_SCENE, dust_position)


func _fire_bullet() -> void:
	fire_bullet_timer.start()
	var bullet := Utils.instantiate_scene_on_main(BULLET_SCENE, muzzle_location.global_position)
	bullet.velocity = Vector2.RIGHT.rotated(gun.rotation) * bullet_speed
	bullet.velocity.x *= sprite.scale.x
	bullet.rotation = bullet.velocity.angle()
