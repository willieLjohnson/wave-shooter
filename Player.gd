extends Sprite

var speed = 150
var velocity = Vector2.ZERO

var bullet = preload("res://Bullet.tscn")

var can_shoot = true
var is_dead = false

func _ready() -> void:
	Global.player = self
	
func _exit_tree() -> void:
	Global.player = null

func _process(delta: float) -> void:
	if is_dead: return
	
	velocity.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	velocity.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	velocity = velocity.normalized()
	
	global_position.x = clamp(global_position.x, 24, 616)
	global_position.y = clamp(global_position.y, 24, 336)
	
	global_position += speed * velocity * delta
	
	if Input.is_action_pressed("shoot") and Global.node_creation_parent != null and can_shoot:
		Global.instance_node(bullet, global_position, Global.node_creation_parent)
		$ReloadSpeed.start()
		can_shoot = false
		Global.camera.screen_shake(5, 0.01)

func _on_Timer_timeout() -> void:
	can_shoot = true


func _on_HitBox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		is_dead = true
		visible = false
		yield(get_tree().create_timer(1), "timeout")
		get_tree().reload_current_scene()
