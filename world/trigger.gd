extends Area2D


signal  area_triggered

var enabled := true


func _on_body_entered(body: Node2D) -> void:
	if enabled:
		area_triggered.emit()
		enabled = false
