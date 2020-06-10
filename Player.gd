extends Sprite

var speed = 150
var velocity = Vector2.ZERO

var bullet = preload("res://Bullet.tscn")

var can_shoot = true
func _process(delta: float) -> void:
	velocity.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	velocity.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	velocity = velocity.normalized()
	
	global_position += speed * velocity * delta
	
	if Input.is_action_pressed("shoot") and Global.node_creation_parent != null and can_shoot:
		Global.instance_node(bullet, global_position, Global.node_creation_parent)
		$ReloadSpeed.start()
		can_shoot = false

func _on_Timer_timeout() -> void:
	can_shoot = true
