extends "res://enemies/enemy.gd"


enum Direction { LEFT = -1, RIGHT = 1 }

@export var walking_direction: Direction = Direction.RIGHT

var state

@onready var sprite: Sprite2D = $Sprite
@onready var floor_left_ray_cast: RayCast2D = $FloorLeftRayCast
@onready var floor_right_ray_cast: RayCast2D = $FloorRightRayCast
@onready var wall_left_ray_cast: RayCast2D = $WallLeftRayCast
@onready var wall_right_ray_cast: RayCast2D = $WallRightRayCast


func _ready() -> void:
	state = walking_direction


func _physics_process(delta: float) -> void:
	match state:
		Direction.LEFT:
			velocity.x = -max_speed
			if not floor_left_ray_cast.is_colliding() or wall_left_ray_cast.is_colliding():
				state = Direction.RIGHT
		
		Direction.RIGHT:
			velocity.x = max_speed
			if not floor_right_ray_cast.is_colliding() or wall_right_ray_cast.is_colliding():
				state = Direction.LEFT
	
	sprite.scale.x = sign(velocity.x)
	
	move_and_slide()
