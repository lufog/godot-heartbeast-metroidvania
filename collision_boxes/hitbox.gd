extends Area2D

@export var damage := 1


func _on_area_entered(area: Area2D) -> void:
	var hurtbox := area as Hurtbox
	if hurtbox:
		hurtbox.hit.emit(damage)
