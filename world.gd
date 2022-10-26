extends Node


var main_instances := LoadedResources.main_instances

@onready var current_level: Node2D = $Level_01


func _ready() -> void:
	if SaveLoad.is_loading:
		SaveLoad.load_game()
		SaveLoad.is_loading = false
	
	main_instances.player.hit_door.connect(self._on_player_hit_door)
	Music.list_play()


func change_levels(door: Door) -> void:
	var offset := current_level.position
	current_level.queue_free()
	var NewLevel := load(door.new_level_path) as PackedScene
	var new_level := NewLevel.instantiate() as Node2D
	add_child(new_level)
	var new_door := get_door_with_connection(door, door.connection)
	new_door.active = false
	var exit_position := new_door.position - offset
	new_level.position = door.position - exit_position


func get_door_with_connection(not_door: Door, connection: Resource) -> Door:
	var doors := get_tree().get_nodes_in_group("Door")
	for door in doors:
		if door.connection == connection and door != not_door:
			return door
	return null


func _on_player_hit_door(door: Door) -> void:
	change_levels.call_deferred(door)
