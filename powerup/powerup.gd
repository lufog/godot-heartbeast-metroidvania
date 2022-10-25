class_name Powerup 
extends Area2D


var player_stats = LoadedResources.player_stats


func _ready() -> void:
	if player_stats.missles_unlocked:
		queue_free()


func _pickup() -> void:
	SoundFx.play("powerup", -10)
