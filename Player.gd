extends KinematicBody2D

export var ACCELERATION = 1890
export var MAX_SPEED = 215
export var FRICTION = 670
export var  damage = 1

var velocity = Vector2.ZERO

var BULLET_SCENE = preload("res://Bullet.tscn")
var BLOOD_SCENE = preload("res://PlayerBlood.tscn")

var can_shoot = true
var is_dead = false setget set_is_dead

onready var default_shape_scale = $Circle.scale

var default_damage = damage
var default_modulate = modulate
var reload_speed = 0.1
var default_reload_speed = reload_speed

var powerup_reset = []

var border = null
var parent = null

func _ready() -> void:
	Global.player = self
	self.is_dead = false
	parent = get_parent()
	if parent: border = parent.get_node("Border")
	
func _exit_tree() -> void:
	Global.player = null

func _physics_process(delta: float) -> void:
	if is_dead: return
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		rotation /= 2
	
	if Input.is_action_pressed("shoot") and Global.node_creation_parent != null and can_shoot:
		var bullet = Global.instance_node(BULLET_SCENE, global_position, Global.node_creation_parent)
		bullet.modulate = modulate
		bullet.damage = damage
		var direction = global_position.direction_to(get_global_mouse_position()).normalized()
		$ReloadSpeed.start()
		can_shoot = false
		Global.camera.screen_shake(5, 0.01)
		velocity += -bullet.recoil * direction
	move()
	squash_stretch(delta)
	modulate = Color.from_hsv(default_modulate.h + (damage * 0.2), default_modulate.s + (damage * 0.2), default_modulate.v - (damage * 0.1), default_modulate.a)
	
func move() -> void:
	velocity = move_and_slide(velocity)
	global_position.x = clamp(global_position.x, border.points[0].x + 15, border.points[3].x - 15)
	global_position.y = clamp(global_position.y, border.points[0].y + 15, border.points[1].y - 15)
	
func squash_stretch(delta) -> void:
	var scale_vel = Vector2(abs(velocity.x), abs(velocity.y))
	var squash = ((scale_vel.y + scale_vel.x) * 0.0002)
	var new_scale = Vector2(squash + default_shape_scale.x, (squash / -1.5) + default_shape_scale.x)
	$Circle.rotation = velocity.angle()
	$Circle.scale = $Circle.scale.move_toward(new_scale, ACCELERATION * delta)
	
func _on_Timer_timeout() -> void:
	can_shoot = true
	$ReloadSpeed.wait_time = reload_speed
	
func _on_HitBox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy") and not is_dead:
		Global.play_sound("res://player-death.wav")
		var blood = Global.instance_node(BLOOD_SCENE, global_position, Global.node_creation_parent)
		blood.rotation = velocity.angle()
		blood.modulate = modulate
		$Node.queue_free()
		self.is_dead = true
		visible = false
		Global.save_game()
		yield(get_tree().create_timer(1), "timeout")
		get_tree().reload_current_scene()

func set_is_dead(value):
	is_dead = value
	Global.is_player_dead = is_dead

func _on_PowerupDuration_timeout() -> void:
	if powerup_reset.find("PowerupReload") != null:
		reload_speed = default_reload_speed
		powerup_reset.erase("PowerupReload")
	if powerup_reset.find("PowerupDamage") != null:
		damage = default_damage
		powerup_reset.erase("PowerupDamage")
