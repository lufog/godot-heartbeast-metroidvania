extends Control


var player_stats := LoadedResources.player_stats

@onready var full: TextureRect = $Full


func _ready() -> void:
	player_stats.player_health_changed.connect(self._on_player_health_changed)


func _on_player_health_changed(value: int) -> void:
	full.size.x = full.texture.get_width() * value + 1
