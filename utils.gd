extends Node


func instantiate_scene_on_main(scene: PackedScene, position: Vector2) -> Node:
	var root := get_tree().root
	var instance := scene.instantiate() as Node2D
	instance.global_position = position
	root.add_child(instance)
	return instance
