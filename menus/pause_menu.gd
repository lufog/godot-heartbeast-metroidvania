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
	var player_alive := _scene_tree.get_nodes_in_group("Player").size() > 0
	if Input.is_action_just_pressed("pause") and player_alive:
		paused = not paused
		if paused:
			SoundFx.play("pause", -10)
		else:
			SoundFx.play("unpause", -10)


func _on_resume_button_pressed() -> void:
	paused = false
	SoundFx.play("click", -10)


func _on_quit_button_pressed() -> void:
	_scene_tree.quit()
