extends Sprite

var speed = 150
var velocity = Vector2.ZERO

var BULLET_SCENE = preload("res://Bullet.tscn")

var can_shoot = true
var is_dead = false

var damage = 1
var default_damage = damage
var reload_speed = 0.1
var default_reload_speed = reload_speed

var powerup_reset = []

func _ready() -> void:
	Global.player = self
	
func _exit_tree() -> void:
	Global.player = null

func _process(delta: float) -> void:
	if is_dead: return
	
	velocity.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	velocity.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	velocity = velocity.normalized()
	
	if Input.is_action_pressed("shoot") and Global.node_creation_parent != null and can_shoot:
		var bullet = Global.instance_node(BULLET_SCENE, global_position, Global.node_creation_parent)
		bullet.damage = damage
		var direction = global_position.direction_to(get_global_mouse_position()).normalized()
		$ReloadSpeed.start()
		can_shoot = false
		Global.camera.screen_shake(5, 0.01)
		velocity += -bullet.recoil * direction
	

	global_position.x = clamp(global_position.x, 24, 616)
	global_position.y = clamp(global_position.y, 24, 336)
	
	global_position += speed * velocity * delta
	
func _on_Timer_timeout() -> void:
	can_shoot = true
	$ReloadSpeed.wait_time = reload_speed

func _on_HitBox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		is_dead = true
		visible = false
		Global.save_game()
		yield(get_tree().create_timer(1), "timeout")
		get_tree().reload_current_scene()


func _on_PowerupDuration_timeout() -> void:
	if powerup_reset.find("PowerupReload") != null:
		reload_speed = default_reload_speed
		powerup_reset.erase("PowerupReload")
	if powerup_reset.find("PowerupDamage") != null:
		damage = default_damage
		powerup_reset.erase("PowerupDamage")
