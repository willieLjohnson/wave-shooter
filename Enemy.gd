extends Sprite

var BLOOD_PARTICLES = preload("res://BloodParticles.tscn")

var speed = 75

var velocity = Vector2()

var stun = false
var health = 3

func _process(delta: float) -> void:
	if Global.player != null and stun == false:
		velocity = global_position.direction_to(Global.player.global_position)
	elif stun:
		velocity = lerp(velocity, Vector2(0, 0), 0.3)
	global_position += velocity * speed * delta
	
	if health <= 0:
		if Global.camera:
			Global.camera.screen_shake(80, 0.2)
		Global.score += 10
		if Global.node_creation_parent != null:
			var blood_particles = Global.instance_node(BLOOD_PARTICLES, global_position, Global.node_creation_parent)
			blood_particles.rotation = velocity.angle()
		queue_free()

func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_damager") and stun == false:
		modulate = Color.white
		stun = true
		velocity = -velocity * 5
		health -= 1
		$StunTimer.start()
		area.get_parent().queue_free()


func _on_StunTimer_timeout() -> void:
	modulate = Color("ff6262")
	stun = false
