class_name Door
extends Area2D


@export var connection: Resource = null
@export_file("*.tscn") var new_level_path := ""

var active := true

func _on_body_entered(player: Player) -> void:
	if active:
		player.hit_door.emit(self)
		active = false


func _on_body_exited(body: Node2D) -> void:
	if not active:
		active = true
