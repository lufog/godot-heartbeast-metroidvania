extends Control


@onready var _scene_tree := get_tree()


func _on_start_button_pressed() -> void:
	_scene_tree.change_scene("res://world.tscn")


func _on_load_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	_scene_tree.quit()
