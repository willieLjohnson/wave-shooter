extends "res://enemies/EnemyCore.gd"



func _physics_process(delta: float) -> void:
	basic_movement_towards_player(delta)
