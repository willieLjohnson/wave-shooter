extends Node2D

export(int) var score_value = 1
export(String) var player_variable_modify
export(float) var player_variable_set
var velocity = Vector2.ZERO

var life_timer
var spawned = false
var value_multiplier = 1

var push_vector = Vector2.ZERO


func on_object_spawned() -> void:
	life_timer = Timer.new()
	life_timer.wait_time = 5
	life_timer.autostart = true
	life_timer.connect("timeout", self, "_on_LifeTimer_timeout")
	self.add_child(life_timer)
	$AnimationPlayer.play("Animate")
	spawned = true
	
func _physics_process(delta: float) -> void:
	if not spawned: return
	velocity += -$Magnet.get_push_vector()
	velocity = lerp(velocity, Vector2.ZERO, 0.1)
	global_position = lerp(global_position, global_position + velocity * 5, 0.3)
	$AnimationPlayer.playback_speed = life_timer.wait_time / ( 0.1 + life_timer.time_left)

func _on_HitBox_area_entered(area: Area2D) -> void:
	if not spawned: return
	if area.is_in_group("player"):
		Global.vibrate()
		Global.score += score_value * value_multiplier
		Global.play_sound("res://assets/sounds/essence-collect.wav", -10)
		var player_variable = area.get_parent().get(player_variable_modify)
		area.get_parent().set(player_variable_modify, player_variable + (player_variable_set * value_multiplier))
		call_deferred("remove_self")


func _on_LifeTimer_timeout() -> void:
	if not spawned: return
	call_deferred("remove_self")

func remove_self():
	if not spawned: return
	life_timer.queue_free()
	get_parent().remove_child(self)
	ObjectPooler.deactivate_obj(self)
	spawned = false

