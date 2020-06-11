extends Sprite

var velocity = Vector2(1, 0)
var default_speed = 250
var speed = default_speed
var initial_speed = default_speed * 3.5

var default_size = 0.75

var damage = 1 setget set_damage
var recoil = damage

var look_once = true

var initial_scale = scale

func _ready() -> void:
	set_scale(Vector2(default_size * damage + velocity.x, default_size * damage + velocity.y))
	speed = initial_speed
	
func _process(delta: float) -> void:
	if look_once:
		look_at(get_global_mouse_position())
		look_once = false
	global_position += velocity.rotated(rotation) * speed * delta
	scale = lerp(scale, initial_scale * damage, 0.15)
	speed = lerp(speed, default_speed, 0.15)

func set_damage(value) -> void:
	damage = value
	recoil = damage
	set_scale(Vector2(default_size * damage + velocity.x , default_size * damage + velocity.y ))

		
func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

