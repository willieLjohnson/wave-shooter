extends Sprite

export(String) var player_variable_modify
export(float) var player_variable_set
export(float) var powerup_duration = 5

func _on_HitBox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		Global.play_sound("res://pickup-powerup.wav")
		area.get_parent().set(player_variable_modify, player_variable_set)
		area.get_parent().get_node("PowerupDuration").wait_time = powerup_duration
		area.get_parent().get_node("PowerupDuration").start()
		area.get_parent().powerup_reset.append(name)
		queue_free()
