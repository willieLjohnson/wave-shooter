extends Sprite



func _on_HitBox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		area.get_parent().reload_speed = 0.05
		area.get_parent().get_node("PowerupDuration").wait_time = 1
		area.get_parent().get_node("PowerupDuration").start()
		area.get_parent().powerup_reset.append("PowerupReload")
		queue_free()
