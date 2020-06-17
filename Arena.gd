extends Node2D

export(Array, PackedScene) var enemies
export(Array, PackedScene) var powerups

var current_wave: int = 1
var wave_max_enemies: int  = 10
var wave_enemies_spawned: int  = 0
var wave_enemies_left: int = wave_max_enemies

signal update_wave

func _ready() -> void:
	randomize()
	Global.node_creation_parent = self
	Global.score = 0
	Global.is_player_dead = false
	var wave_label = get_node("/root/Arena/UI/Control/WaveContainer/CurrentWave")
	self.connect("update_wave", wave_label, "update_wave")
	
func _process(_delta: float) -> void:
	if Global.is_player_dead:
		$UI/Control/HighScore.visible = true
	
func _exit_tree() -> void:
	Global.node_creation_parent = null


func _on_EnemySpawnTimer_timeout() -> void:
	if wave_enemies_spawned < wave_max_enemies:
		var enemy_position = Vector2(rand_range(-160, 670), rand_range(-90, 390))
		while enemy_position.x < 640 and enemy_position.x > -80 and enemy_position.y < 360 and enemy_position.y > -45:
			enemy_position = Vector2(rand_range(-160, 670), rand_range(-90, 390))
		
		var rand_enemy_index = round(rand_range(0, enemies.size() - 1))
		rand_enemy_index = clamp(rand_enemy_index, 0, current_wave - 1)
		Global.instance_node(enemies[rand_enemy_index], enemy_position, self)
		wave_enemies_spawned += 1
	else:
		$DifficultyTimer.paused = true

func enemy_died() -> void:
	wave_enemies_left -= 1
	if wave_enemies_left == 0:
		new_wave()
	print(wave_enemies_left)
		
func new_wave() -> void:
	current_wave += 1
	wave_enemies_spawned = 0
	wave_max_enemies += (1.5 * current_wave)
	wave_enemies_left = wave_max_enemies
	emit_signal("update_wave", current_wave)
	$DifficultyTimer.paused = false
	
func _on_DifficultyTimer_timeout() -> void:
	if 	$EnemySpawnTimer.wait_time > 0.5:
		$EnemySpawnTimer.wait_time -= 0.025


func _on_PowerupSpawnTimer_timeout() -> void:
	var powerup_position = Vector2(rand_range(0, 640), rand_range(0, 360))
	var rand_powerup_index = round(rand_range(0, powerups.size() - 1))
	Global.instance_node(powerups[rand_powerup_index], powerup_position, self)
