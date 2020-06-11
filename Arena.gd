extends Node2D

export(Array, PackedScene) var enemies
export(Array, PackedScene) var powerups

func _ready() -> void:
	randomize()
	Global.node_creation_parent = self
	Global.score = 0
	
func _exit_tree() -> void:
	Global.node_creation_parent = null


func _on_EnemySpawnTimer_timeout() -> void:
	var enemy_position = Vector2(rand_range(-160, 670), rand_range(-90, 390))
	while enemy_position.x < 640 and enemy_position.x > -80 and enemy_position.y < 360 and enemy_position.y > -45:
		enemy_position = Vector2(rand_range(-160, 670), rand_range(-90, 390))
		
	var rand_enemy_index = round(rand_range(0, enemies.size() - 1))
	Global.instance_node(enemies[rand_enemy_index], enemy_position, self)



func _on_DifficultyTimer_timeout() -> void:
	if 	$EnemySpawnTimer.wait_time > 0.5:
		$EnemySpawnTimer.wait_time -= 0.025


func _on_PowerupSpawnTimer_timeout() -> void:
	var powerup_position = Vector2(rand_range(0, 640), rand_range(0, 360))
	var rand_powerup_index = round(rand_range(0, powerups.size() - 1))
	Global.instance_node(powerups[rand_powerup_index], powerup_position, self)
