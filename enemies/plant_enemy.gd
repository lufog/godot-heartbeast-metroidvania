extends "res://enemies/enemy.gd"


const EnemyBullet: PackedScene = preload("res://projectile/enemy_bullet.tscn")

@export var bullet_speed := 30
@export var spread := 30.0


@onready var bullet_spawn_point: Marker2D = $BulletSpawnPoint
@onready var fire_direction: Marker2D = $FireDirection


func fire_bullet() -> void:
	var bullet := Utils.instantiate_scene_on_main(EnemyBullet, bullet_spawn_point.global_position) as Node2D
	var bullet_velocity := (fire_direction.global_position - bullet_spawn_point.global_position).normalized() * bullet_speed
	var spread_angle := randf_range(-spread / 2, spread / 2)
	bullet_velocity = bullet_velocity.rotated(deg_to_rad(spread_angle))
	bullet.velocity = bullet_velocity
