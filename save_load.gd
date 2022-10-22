extends Node


const _SAVEFILE_PATH := "user://savegame.save"

var is_loading := false


func save_game() -> void:
	var save_file := FileAccess.open(_SAVEFILE_PATH, FileAccess.WRITE)
	var persisting_nodes := get_tree().get_nodes_in_group("Persists")
	for node in persisting_nodes:
		var node_data = node.save()
		save_file.store_line(JSON.stringify(node_data))


func load_game() -> void:
	if not FileAccess.file_exists(_SAVEFILE_PATH):
		return
	
	var persisting_nodes := get_tree().get_nodes_in_group("Persists")
	for node in persisting_nodes:
		node.queue_free()
	
	var save_file := FileAccess.open(_SAVEFILE_PATH, FileAccess.READ)
	while not save_file.eof_reached():
		var node_data = JSON.parse_string(save_file.get_line())
		if node_data != null:
			var new_node := load(node_data["filename"]).instantiate() as Node2D
			get_node(node_data["parent"]).add_child(new_node, true)
			new_node.position = Vector2(node_data["position_x"], node_data["position_y"])
			for property in node_data.keys():
				if (property == "filename" or property == "parent"
						or property == "position_x" or property == "position_y"):
					continue
				new_node.set(property, node_data[property])
