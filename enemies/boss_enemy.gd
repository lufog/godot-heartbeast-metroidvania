extends "res://enemies/enemy.gd"


signal died

@export var acceleration := 70

var main_instances := LoadedResources.main_instances
var bullet_scene: PackedScene = preload("res://projectile/enemy_bullet.tscn")

@onready var wall_check_left: RayCast2D = $WallCheckLeft
@onready var wall_check_right: RayCast2D = $WallCheckRight


func _process(delta: float) -> void:
	chace_player(delta)


func chace_player(delta: float) -> void:
	var player := main_instances.player
	if player != null:
		var direction_to_move := signf(player.global_position.x - global_position.x)
		velocity.x += acceleration * direction_to_move * delta
		velocity.x = clampf(velocity.x, -max_speed, max_speed)
		global_position.x += velocity.x * delta
		rotation = lerpf(rotation, deg_to_rad((velocity.x / max_speed) * 10), 0.3)
		
		if ((wall_check_left.is_colliding() and velocity.x < 0)
			or (wall_check_right.is_colliding() and velocity.x > 0)):
			velocity.x *= -0.5


func fire_bullet() -> void:
	var bullet := Utils.instantiate_scene_on_main(bullet_scene, global_position) as Projectile
	var bullet_velocity := Vector2.DOWN * 50
	bullet_velocity = bullet_velocity.rotated(deg_to_rad(randf_range(-30, 30)))
	bullet.velocity = bullet_velocity


func _on_fire_bullet_timer_timeout() -> void:
	fire_bullet()
