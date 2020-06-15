extends Node2D

export(int) var score_value = 1
export(String) var player_variable_modify
export(float) var player_variable_set
var velocity

func _physics_process(delta: float) -> void:
	velocity += -$Magnet.get_push_vector()
	velocity = lerp(velocity, Vector2.ZERO, 0.1)
	global_position = lerp(global_position, global_position + velocity * 10, 0.3)
	$PowerupReload/AnimationPlayer.playback_speed = $LifeTimer.wait_time / $LifeTimer.time_left
func _on_HitBox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		Global.score += score_value
		Global.play_sound("res://essence-collect.wav", -10)
		var player_variable = area.get_parent().get(player_variable_modify)
		area.get_parent().set(player_variable_modify, player_variable + player_variable_set)
		queue_free()


func _on_LifeTimer_timeout() -> void:
	queue_free()
	
