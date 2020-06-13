extends Area2D

const HIT_EFFECT_SCENE = preload("res://HitEffect.tscn")

var velocity = Vector2(1, 0)
var default_speed = 250
var speed = default_speed
var initial_speed = default_speed * 3.5

var default_size = 0.1

var damage = 1 setget set_damage
var recoil = damage * default_speed * 0.15

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
	var audioPitch = $AudioStreamPlayer.pitch_scale
	$AudioStreamPlayer.pitch_scale = lerp(audioPitch, 0.9 / damage, 0.01)
	
func set_damage(value) -> void:
	damage = value
	recoil = damage * default_speed * 0.2
	set_scale(Vector2((default_size * damage + velocity.x) * 0.5, (default_size * damage + velocity.y) * 0.5))  

		
func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

