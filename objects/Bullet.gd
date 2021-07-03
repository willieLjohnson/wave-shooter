extends Area2D

const HIT_EFFECT_SCENE = preload("res://effects/HitEffect.tscn")

export(bool) var piercing = false

var velocity = Vector2(1, 0)
var default_speed = 250
var speed = default_speed
var initial_speed = default_speed * 3.5


var damage = 1 setget set_damage
var recoil = (damage) + (default_speed * 0.1)

var look_once = true

var default_scale = scale
var direction = Vector2.ZERO


func _ready() -> void:
	update_scale()
	speed = initial_speed
	
func init(damage: float, direction: Vector2, color: Color) -> void:
	self.direction = direction
	self.damage = damage
	self.modulate = color
	look_once = true
	look_at(direction)
			
func _process(delta: float) -> void:
	if look_once:
		look_at(direction)
		look_once = false
	global_position += velocity.rotated(rotation) * speed * delta
	speed = lerp(speed, default_speed, 0.15)
	update_scale()
	
func set_damage(value) -> void:
	damage = value
	recoil = damage * default_speed * 0.2
	update_scale()
	var audioPitch = $AudioStreamPlayer.pitch_scale
	$AudioStreamPlayer.pitch_scale = 0.9 / damage
	
func update_scale() -> void:
	var scale_vel = Vector2(abs(velocity.x), abs(velocity.y))
	var squash = ((scale_vel.y + scale_vel.x))
	var new_scale = Vector2(squash + default_scale.x + (damage * 0.2), (squash / -1.5) + default_scale.x  + (damage * 0.35))
	set_scale(new_scale)
	
func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

