extends Node2D

var text = "0" setget set_text

func _ready() -> void:
	$Label.text = text

func _on_Timer_timeout() -> void:
	queue_free()

func set_text(new_text: String) -> void:
	text = new_text
	$Label.text = text
