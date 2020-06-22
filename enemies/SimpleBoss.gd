extends "res://enemies/EnemyCore.gd"

var is_special_attack = false
var special_attack_target = null

func _physics_process(delta: float) -> void:
	if !is_special_attack:
		basic_movement_towards_player(delta)
	else:
		special_attack_movement(delta)	
		if special_attack_target == null:
			look_at(Global.player.global_position)

func _on_SpecialAttackTimer_timeout() -> void:
	is_special_attack = true
	yield(get_tree().create_timer(2), "timeout")
	special_attack_target = Global.player.global_position
	$SpecialAttackDuration.start()
	
func special_attack_movement(delta: float) -> void:
	if special_attack_target == null: return
	velocity = velocity.move_toward(global_position.direction_to(special_attack_target) * MAX_SPEED * 5, ACCELERATION * 10 * delta)
	velocity = move_and_slide(velocity)
	

func _on_SpecialAttackDuration_timeout() -> void:
	is_special_attack = false
	special_attack_target = null
	$SpecialAttackTimer.start()
