extends Sprite

var BLOOD_PARTICLES = preload("res://BloodParticles.tscn")

export(int) var speed = 75
export(int) var health = 3
export(int) var knockback = 600
export(int) var screen_shake_intensity = 60

var velocity = Vector2()

var stun = false

onready var current_color = modulate

func _process(_delta: float) -> void:
	if health <= 0:
		if Global.camera:
			Global.camera.screen_shake(screen_shake_intensity, 0.2)

		Global.score += 10
		if Global.node_creation_parent != null:
			var blood_particles = Global.instance_node(BLOOD_PARTICLES, global_position, Global.node_creation_parent)
			blood_particles.rotation = velocity.angle()
			blood_particles.modulate = Color.from_hsv(current_color.h, 0.75, current_color.v)
		queue_free()

func basic_movement_towards_player(delta: float) -> void:
	if Global.player != null and stun == false:
		velocity = global_position.direction_to(Global.player.global_position)
		global_position += velocity * speed * delta
	elif stun:
		velocity = lerp(velocity, Vector2(0, 0), 0.3)
		global_position += velocity * delta


func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_damager") and stun == false:
		Global.camera.screen_shake(10, 0.02)
		modulate = Color.white
		stun = true
		velocity = -velocity * knockback
		health -= area.get_parent().damage
		$StunTimer.start()
		area.get_parent().queue_free()


func _on_StunTimer_timeout() -> void:
	modulate = Color(current_color)
	stun = false
