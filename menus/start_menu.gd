extends Control


@onready var _scene_tree := get_tree()


func _on_start_button_pressed() -> void:
	_scene_tree.change_scene_to_file("res://world.tscn")
	SoundFx.play("click", -10)


func _on_load_button_pressed() -> void:
	SaveLoad.is_loading = true
	_scene_tree.change_scene_to_file("res://world.tscn")
	SoundFx.play("click", -10)


func _on_quit_button_pressed() -> void:
	_scene_tree.quit()
