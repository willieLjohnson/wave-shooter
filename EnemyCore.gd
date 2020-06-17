extends KinematicBody2D

const BLOOD_PARTICLES = preload("res://BloodParticles.tscn")
const ESSENCE_SCENE = preload("res://Essence.tscn")
const POPUP_LABEL_SCENE = preload("res://PopupLabel.tscn")

export(int) var ACCELERATION = 500
export(int) var MAX_SPEED = 85
export(int) var FRICTION = 100
export(String) var essence_upgrade_variable = "damage"
export(float) var essence_upgrade_amount = 0.01
export(float) var knockback = 2
export(int) var health = 3
export(int) var screen_shake_intensity = 60
export(int) var score_value = 10

onready var softCollision = $SoftCollision

var velocity = Vector2()

var stun = false

onready var base_modulate = modulate

signal died

func _ready() -> void:
	var arena = get_node("/root/Arena")
	self.connect("died", arena, "enemy_died")

func _process(delta: float) -> void:
	if health <= 0:
		Global.play_sound("res://enemy-death.wav")
		if Global.camera:
			Global.camera.screen_shake(screen_shake_intensity, 0.2)
		
		Global.score += score_value
		if Global.node_creation_parent != null:
			var blood_particles = Global.instance_node(BLOOD_PARTICLES, global_position, Global.node_creation_parent)
			blood_particles.get_node("Particles").scale_amount = 0.3 * scale.x
			blood_particles.rotation = velocity.angle()
			blood_particles.modulate = Color.from_hsv(base_modulate.h, base_modulate.s, base_modulate.v * 0.5)
			
			var popup_label = Global.instance_node(POPUP_LABEL_SCENE, global_position, Global.node_creation_parent)
			popup_label.text = str(score_value)
			popup_label.modulate = base_modulate
			popup_label.z_index = 10
		
		emit_signal("died")
		queue_free()
		for essence in range(score_value / 3):
			var essence_instance = Global.instance_node(ESSENCE_SCENE, global_position, Global.node_creation_parent)
			essence_instance.modulate = base_modulate
			essence_instance.player_variable_modify = essence_upgrade_variable
			essence_instance.player_variable_set = essence_upgrade_amount
			essence_instance.velocity = Vector2(rand_range(-1, 1), rand_range(-1, 1))
	if Global.is_player_dead:
		velocity = velocity.move_toward(Vector2(rand_range(-1, 1), rand_range(-1, 1)) * MAX_SPEED * 3, ACCELERATION * 3 * delta)
		velocity = move_and_slide(velocity)
		
func basic_movement_towards_player(delta: float) -> void:
	move(delta)
	rotation = lerp(rotation, velocity.angle(), 0.1)

func spinner_movement_towards_player(spin_speed: float, delta: float) -> void:
	move(delta)
	rotation += spin_speed * delta
	
func move(delta: float) -> void:
	if Global.player != null and stun == false:
		velocity = velocity.move_toward(global_position.direction_to(Global.player.global_position) * MAX_SPEED, ACCELERATION * delta)
	elif stun:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	if softCollision.is_colliding() and !$SoftCollision.is_in_group("boss"):
		velocity += softCollision.get_push_vector() * delta * ACCELERATION
		
	velocity = move_and_slide(velocity)
	
func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_damager") and stun == false:
		var hit_effect = Global.instance_node(area.HIT_EFFECT_SCENE, area.global_position, Global.node_creation_parent)
		hit_effect.modulate = base_modulate
		Global.play_sound("res://enemy-hurt-2.wav", 1, 1.2 - (health * 0.005))
		if not area.piercing:
			stun = true
			area.queue_free()
			Global.camera.screen_shake(10, 0.02)
			modulate = Color.white
			$StunTimer.start()
			velocity = (-velocity.rotated(rotation) / 2) * knockback
		else:
			stun = false
			Global.camera.screen_shake(5, 0.02)
			area.damage *= 2
			area.speed *= 2
			
		health -= area.damage
		
		var popup_label = Global.instance_node(POPUP_LABEL_SCENE, area.global_position, Global.node_creation_parent)
		popup_label.text = str(-area.damage)
		popup_label.scale = Vector2(0.8, 0.8)
		popup_label.modulate = area.modulate
		popup_label.z_index = 5 
	if area.is_in_group("boss"):
		velocity += area.get_parent().velocity
		
func _on_StunTimer_timeout() -> void:
	modulate = Color(base_modulate)
	stun = false
