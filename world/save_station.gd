extends StaticBody2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_save_area_body_entered(body: Node2D) -> void:
	animation_player.play("save")
	SaveLoad.save_game()
