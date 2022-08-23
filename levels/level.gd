extends Node2D


const World: GDScript = preload("res://world.gd")


func _ready() -> void:
	var parent := get_parent()
	if parent is World:
		parent.current_level = self
