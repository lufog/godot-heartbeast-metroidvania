extends "res://enemies/enemy.gd"


enum Direction {LEFT = -1, RIGHT = 1}

@export var walking_direction: Direction = Direction.RIGHT

@onready var floor_ray_cast: RayCast2D = $FloorRayCast
@onready var wall_ray_cast: RayCast2D = $WallRayCast


func _ready() -> void:
	wall_ray_cast.target_position.x *= walking_direction


func _physics_process(delta: float) -> void:
	if wall_ray_cast.is_colliding():
		global_position = wall_ray_cast.get_collision_point()
		var normal := wall_ray_cast.get_collision_normal()
		rotation = normal.rotated(deg2rad(90)).angle()
	else:
		floor_ray_cast.rotation = deg2rad(-max_speed * 10 * walking_direction * delta)
		if floor_ray_cast.is_colliding():
			global_position = floor_ray_cast.get_collision_point()
			var normal := floor_ray_cast.get_collision_normal()
			rotation = normal.rotated(deg2rad(90)).angle()
		else:
			rotation += deg2rad(20 * walking_direction)
