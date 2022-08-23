class_name Player
extends CharacterBody2D

const DustEffectScene: PackedScene = preload("res://effects/dust_effect/dust_effect.tscn")
const WallDustEffectScene: PackedScene = preload("res://effects/wall_dust_effect/wall_dust_effect.tscn")
const JumpEffectScene: PackedScene =preload("res://effects/jump_effect/jump_effect.tscn")
const BulletScene: PackedScene = preload("res://projectile/player_bullet.tscn")
const MissleScene: PackedScene = preload("res://projectile/player_missle.tscn")

enum { MOVE, WALL_SLIDE }

signal hit_door(door: Door)

var stats = LoadedResources.player_stats
var main_instances = LoadedResources.main_instances

@export var max_speed: float = 64
@export var acceleration: float = 256
@export var friction: float = 0.25
@export var jump_force: float = 128
@export var wall_slide_speed: float = 32
@export var max_wall_slide_speed: float = 128
@export var max_slope_angle: float = 46
@export var bullet_speed: float = 250
@export var missle_speed: float = 150
@export var invincible := false

var state := MOVE
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping: bool = false
var double_jump: bool = true

@onready var sprite: Sprite2D = $Sprite
@onready var gun: Node2D = $Sprite/PlayerGun
@onready var muzzle_location: Node2D = $Sprite/PlayerGun/Sprite/MuzzleLocation
@onready var sprite_animation_player: AnimationPlayer = $SpriteAnimationPlayer
@onready var blink_animation_player: AnimationPlayer = $BlinkAnimationPlayer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var fire_bullet_timer: Timer = $FireBulletTimer
@onready var powerup_detector: Area2D = $PowerupDetector


func _ready() -> void:
	stats.player_died.connect(self._on_died)
	main_instances.player = self


func _exit_tree() -> void:
	main_instances.player = null


func _physics_process(delta: float) -> void:
	match state:
		MOVE:
			if not is_on_floor() and is_on_wall():
				state = WALL_SLIDE
				double_jump = true
				_create_dust_effect()
			
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
				velocity.x = lerpf(velocity.x, 0, friction)
			
			if is_on_floor():
				is_jumping = false
				double_jump = true
			else:
				# Apply gravity.
				velocity.y += gravity * delta
				velocity.y = clamp(velocity.y, -jump_force, jump_force)

				sprite_animation_player.play("jump")
				if Input.is_action_just_released("jump") and velocity.y < -jump_force / 2:
					velocity.y = -jump_force / 2
				
				if Input.is_action_just_pressed("jump") and double_jump:
					Utils.instantiate_scene_on_main(JumpEffectScene, global_position)
					velocity.y = -jump_force * 0.75
					double_jump = false
			
			if is_on_floor() or not coyote_timer.is_stopped():
				if Input.is_action_just_pressed("jump"):
					Utils.instantiate_scene_on_main(JumpEffectScene, global_position)
					velocity.y = -jump_force
					is_jumping = true
					coyote_timer.stop()
			
			var was_on_flor = is_on_floor()

			move_and_slide()

			if was_on_flor and not is_on_floor() and not is_jumping:
				coyote_timer.start()
			
			if not was_on_flor and is_on_floor():
				Utils.instantiate_scene_on_main(JumpEffectScene, global_position)
		
		WALL_SLIDE:
			sprite_animation_player.play("wall_slide")
			var wall_axis := _get_wall_axis()
			if wall_axis != 0:
				sprite.scale.x = wall_axis
			
			if wall_axis == 0 or is_on_floor():
				state = MOVE
			
			if Input.is_action_just_pressed("jump"):
				velocity.x = wall_axis * max_speed
				velocity.y = -jump_force / 1.25
				state = MOVE
				var dust_effect_position := global_position + Vector2(4 * wall_axis, -2)
				var dust_effect := Utils.instantiate_scene_on_main(WallDustEffectScene, dust_effect_position)
				dust_effect.scale.x = wall_axis
			
			var direction := Input.get_axis("move_left", "move_right")
			if direction != 0:
				velocity.x = acceleration * direction * delta
			
			var slide_speed: float
			if Input.is_action_pressed("slide"):
				slide_speed = max_wall_slide_speed
			else:
				slide_speed = wall_slide_speed
			
			velocity.y = min(velocity.y + gravity * delta, slide_speed)
			move_and_slide()
	
	if Input.is_action_pressed("fire") and fire_bullet_timer.is_stopped():
		_fire_bullet()
	
	if Input.is_action_pressed("fire_missle") and fire_bullet_timer.is_stopped():
		if stats.missles_unlocked and stats.missles > 0:
			_fire_missle()
			stats.missles -= 1


func _on_hurtbox_hit(damage) -> void:
	if not invincible:
		Events.add_screen_shake.emit(0.4, 0.5)
		stats.health -= damage
		blink_animation_player.play("blink")


func _on_died() -> void:
	queue_free()


func _get_wall_axis() -> int:
	var is_right_wall = test_move(transform, Vector2.RIGHT)
	var is_left_wall = test_move(transform, Vector2.LEFT)
	return int(is_left_wall) - int(is_right_wall)


func _create_dust_effect() -> void:
	var dust_position := global_position + Vector2(randf_range(-4, 4), 0)
	Utils.instantiate_scene_on_main(DustEffectScene, dust_position)


func _fire_bullet() -> void:
	fire_bullet_timer.start()
	var bullet := Utils.instantiate_scene_on_main(BulletScene, muzzle_location.global_position)
	bullet.velocity = Vector2.RIGHT.rotated(gun.rotation) * bullet_speed
	bullet.velocity.x *= sprite.scale.x
	bullet.rotation = bullet.velocity.angle()


func _fire_missle() -> void:
	fire_bullet_timer.start()
	var missle := Utils.instantiate_scene_on_main(MissleScene, muzzle_location.global_position)
	missle.velocity = Vector2.RIGHT.rotated(gun.rotation) * missle_speed
	missle.velocity.x *= sprite.scale.x
	missle.rotation = missle.velocity.angle()
	velocity -= missle.velocity * 0.25


func _on_powerup_detector_area_entered(area: Area2D) -> void:
	if area is Powerup:
		area._pickup()
