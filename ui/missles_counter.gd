extends HBoxContainer


var player_stats := LoadedResources.player_stats

@onready var missles_value: Label = $Value


func _ready() -> void:
	visible = false
	player_stats.player_missles_changed.connect(self._update_missles_value)
	player_stats.player_missles_unlocked.connect(self._update_missles_visibility)


func _update_missles_value(value: int) -> void:
	missles_value.text = str(value)


func _update_missles_visibility(value: bool) -> void:
	visible = value
