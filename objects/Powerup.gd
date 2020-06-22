extends Sprite

export(String) var player_variable_modify
export(float) var player_variable_set
export(float) var powerup_duration = 5

func _physics_process(delta: float) -> void:
	$AnimationPlayer.playback_speed = $LifeTimer.wait_time / $LifeTimer.time_left
		
func _on_HitBox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		Global.play_sound("res://assets/sounds/pickup-powerup.wav")
		var player_variable = area.get_parent().get(player_variable_modify)
		area.get_parent().set(player_variable_modify, player_variable + player_variable_set)
		area.get_parent().get_node("PowerupDuration").wait_time = powerup_duration
		area.get_parent().get_node("PowerupDuration").start()
		area.get_parent().powerup_reset.append(name)
		queue_free()


func _on_LifeTimer_timeout() -> void:
	queue_free()
