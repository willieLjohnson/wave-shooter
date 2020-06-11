extends Node2D

var SEEKER_ENEMY = preload("res://Enemy.tscn")

func _ready() -> void:
	Global.node_creation_parent = self
	Global.score = 0
	
func _exit_tree() -> void:
	Global.node_creation_parent = null


func _on_EnemySpawnTimer_timeout() -> void:
	var enemy_position = Vector2(rand_range(-160, 670), rand_range(-90, 390))
	while enemy_position.x < 640 and enemy_position.x > -80 and enemy_position.y < 360 and enemy_position.y > -45:
		enemy_position = Vector2(rand_range(-160, 670), rand_range(-90, 390))
	Global.instance_node(SEEKER_ENEMY, enemy_position, self)
	$EnemySpawnTimer.wait_time *= 0.95
