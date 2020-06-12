extends Sprite

var velocity = Vector2(1, 0)
var default_speed = 250
var speed = default_speed
var initial_speed = default_speed * 3.5

var default_size = 0.1

var damage = 1 setget set_damage
var recoil = damage * 1.3

var look_once = true

var default_scale = scale

func _ready() -> void:
	set_scale(Vector2((default_size * damage + velocity.x) * 0.5, (default_size * damage + velocity.y) * 0.5))  
	speed = initial_speed
	look_at(get_global_mouse_position())
	
func _process(delta: float) -> void:
	if look_once:
		look_at(get_global_mouse_position())
		look_once = false
	global_position += velocity.rotated(rotation) * speed * delta
	scale = lerp(scale, default_scale * damage, 0.15)
	speed = lerp(speed, default_speed, 0.15)

func set_damage(value) -> void:
	damage = value
	recoil = damage * default_speed * 0.25
	set_scale(Vector2((default_size * damage + velocity.x) * 0.5, (default_size * damage + velocity.y) * 0.5))  
	$AudioStreamPlayer.pitch_scale = 1 / damage
		
func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

