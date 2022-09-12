extends Node2D


const World: GDScript = preload("res://world.gd")


func _ready() -> void:
	var parent := get_parent()
	if parent is World:
		parent.current_level = self


func save() -> Dictionary:
	return {
		"filename": scene_file_path,
		"parent": get_parent().get_path(),
		"position_x": position.x,
		"position_y": position.y,
	}
