extends Node2D

var score = 0 setget set_score

func _ready() -> void:
	$Label.text = str(score)

func _on_Timer_timeout() -> void:
	queue_free()

func set_score(new_score: int) -> void:
	score = new_score
	$Label.text = str(score)
