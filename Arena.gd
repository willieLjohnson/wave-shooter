extends Node2D

export(Array, PackedScene) var enemies
export(Array, PackedScene) var bosses
export(Array, PackedScene) var powerups

var current_wave: int = 1
var wave_max_enemies: int  = 10
var boss_wave_max_enemies: int  = 1
var wave_enemies_spawned: int  = 0
var wave_enemies_left: int = wave_max_enemies
var is_boss_wave = false

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
	if wave_enemies_spawned < wave_max_enemies and !is_boss_wave:
		var enemy_position = Vector2(rand_range(-170, 680), rand_range(-100, 400))
		while enemy_position.x <= 630 and enemy_position.x > -70 and enemy_position.y < 340 and enemy_position.y > -35:
			enemy_position = Vector2(rand_range(-170, 680), rand_range(-100, 400))
		
		var rand_enemy_index = round(rand_range(0, enemies.size() - 1))
		rand_enemy_index = clamp(rand_enemy_index, 0, current_wave - 1)
		Global.instance_node(enemies[rand_enemy_index], enemy_position, self)
		wave_enemies_spawned += 1
	elif is_boss_wave and wave_enemies_spawned < wave_max_enemies:
		var boss_position = Vector2(rand_range(-160, 670), rand_range(-90, 390))
		while boss_position.x < 640 and boss_position.x > -80 and boss_position.y < 360 and boss_position.y > -45:
			boss_position = Vector2(rand_range(-160, 670), rand_range(-90, 390))
		var rand_boss_index = round(rand_range(0, bosses.size() - 1))
		var boss = Global.instance_node(bosses[rand_boss_index], boss_position, self)
		boss.health *= current_wave / 5
		$EnemySpawnTimer.paused = true
		wave_enemies_spawned += 1
	else:
		$DifficultyTimer.paused = true

func enemy_died() -> void:
	wave_enemies_left -= 1
	if wave_enemies_left == 0:
		new_wave()
		
func new_wave() -> void:
	current_wave += 1
	is_boss_wave = current_wave % 5 == 0
	if is_boss_wave:
		wave_max_enemies = boss_wave_max_enemies
	else: 
		wave_max_enemies += (5 * current_wave)
	wave_enemies_spawned = 0
	wave_enemies_left = wave_max_enemies
	emit_signal("update_wave", current_wave, is_boss_wave)
	$DifficultyTimer.paused = false
	$EnemySpawnTimer.paused = false
	
func _on_DifficultyTimer_timeout() -> void:
	if 	$EnemySpawnTimer.wait_time > 1:
		$EnemySpawnTimer.wait_time -= 0.010


func _on_PowerupSpawnTimer_timeout() -> void:
	var powerup_position = Vector2(rand_range(0, 640), rand_range(0, 360))
	var rand_powerup_index = round(rand_range(0, powerups.size() - 1))
	Global.instance_node(powerups[rand_powerup_index], powerup_position, self)
