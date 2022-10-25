extends Node


const SOUNDS_PATH := "res://sound_fx/sounds/"

var sound_players: Array[AudioStreamPlayer]
var sounds := {
	"bullet"    : load(SOUNDS_PATH + "bullet.wav"),
	"click"     : load(SOUNDS_PATH + "click.wav"),
	"enemy_die" : load(SOUNDS_PATH + "enemy_die.wav"),
	"explosion" : load(SOUNDS_PATH + "explosion.wav"),
	"hurt"      : load(SOUNDS_PATH + "hurt.wav"),
	"step"      : load(SOUNDS_PATH + "step.wav"),
	"jump"      : load(SOUNDS_PATH + "jump.wav"),
	"powerup"   : load(SOUNDS_PATH + "powerup.wav"),
	"pause"     : load(SOUNDS_PATH + "pause.wav"),
	"unpause"   : load(SOUNDS_PATH + "unpause.wav"),
}


func _ready() -> void:
	for child in get_children():
		sound_players.append(child as AudioStreamPlayer)


func play(sound_string: String, volume_db := 0.0, pitch_scale := 1.0) -> void:
	for sound_player in sound_players:
		if not sound_player.playing:
			sound_player.volume_db = volume_db
			sound_player.pitch_scale = pitch_scale
			sound_player.stream = sounds[sound_string]
			sound_player.play()
			return
