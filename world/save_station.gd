extends StaticBody2D


var player_stats := LoadedResources.player_stats

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_save_area_body_entered() -> void:
	animation_player.play("save")
	SaveLoad.save_game()
	player_stats.refill_stats()
	SoundFx.play("powerup", -10, 0.6)
