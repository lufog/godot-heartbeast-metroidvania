extends "res://enemies/enemy.gd"


@export var acceleration := 200

var main_instances := LoadedResources.main_instances

@onready var sprite: Sprite2D = $Sprite


func _physics_process(delta: float) -> void:
	var player := main_instances.player
	if player != null:
		chace_player(player, delta)


func chace_player(player: Player, delta: float) -> void:
	var direction := (player.global_position - global_position).normalized()
	velocity += acceleration * direction * delta
	velocity = velocity.limit_length(max_speed)
	sprite.flip_h = direction.x > 0
	move_and_slide()
	
