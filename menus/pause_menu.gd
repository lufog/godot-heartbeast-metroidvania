extends ColorRect


var paused := false:
	get:
		return paused
	set(value):
		paused = value
		_scene_tree.paused = paused
		visible = paused

@onready var _scene_tree := get_tree()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		paused = not paused


func _on_resume_button_pressed() -> void:
	paused = false


func _on_quit_button_pressed() -> void:
	_scene_tree.quit()
