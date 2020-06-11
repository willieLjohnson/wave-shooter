extends Sprite

var velocity = Vector2(1, 0)
var base_speed = 250
var speed = base_speed
var initial_speed = base_speed * 3.5
var damage

var recoil = initial_speed * 0.15

var look_once = true

var current_scale = scale

func _ready() -> void:
	set_scale(Vector2(0.5 + velocity.x, 0.5 + velocity.y))
	speed = initial_speed
	
func _process(delta: float) -> void:
	if look_once:
		look_at(get_global_mouse_position())
		look_once = false
	global_position += velocity.rotated(rotation) * speed * delta
	scale = lerp(scale, current_scale, 0.15)
	speed = lerp(speed, base_speed, 0.15)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
