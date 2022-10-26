extends Node


@export var music_list: Array[AudioStream]

var music_list_index := 0

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func list_play() -> void:
	assert(music_list.size() > 0)
	audio_stream_player.stream = music_list[music_list_index]
	audio_stream_player.play()
	music_list_index += 1
	if music_list_index == music_list.size():
		music_list_index = 0


func list_stop() -> void:
	audio_stream_player.stop()


func _on_audio_stream_player_finished() -> void:
	list_play()
