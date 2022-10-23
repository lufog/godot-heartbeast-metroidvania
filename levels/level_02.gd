extends "res://levels/level.gd"


const PLAYER_BIT := 2

@onready var block_door: TileMap = $BlockDoor


func _on_trigger_area_triggered() -> void:
	block_door.show()
	block_door.tile_set.set_physics_layer_collision_layer(0, PLAYER_BIT)


func _on_boss_enemy_died() -> void:
	block_door.hide()
	block_door.tile_set.set_physics_layer_collision_layer(0, 0)
