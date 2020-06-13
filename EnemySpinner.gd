extends "res://EnemyCore.gd"

func _physics_process(delta: float) -> void:
	spinner_movement_towards_player(20, delta)
