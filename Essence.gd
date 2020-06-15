extends Node2D

export(String) var player_variable_modify
export(float) var player_variable_set

func _on_HitBox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		Global.play_sound("res://essence-collect.wav")
		var player_variable = area.get_parent().get(player_variable_modify)
		area.get_parent().set(player_variable_modify, player_variable + player_variable_set)
		queue_free()
