extends Sprite

var speed = 150
var velocity = Vector2.ZERO

func _process(delta: float) -> void:
	velocity.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	velocity.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	velocity = velocity.normalized()
	
	global_position += speed * velocity * delta
