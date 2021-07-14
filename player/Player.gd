extends KinematicBody2D

export var ACCELERATION = 1890
export var MAX_SPEED = 215 setget set_max_speed
export var FRICTION = 670

export(float) var base_damage = 1 setget set_base_damage
export(float) var base_reload_speed = 0.2 setget set_base_reload_speed

export(bool) var god_mode = false

const BULLET_SCENE = preload("res://objects/Bullet.tscn")
const BLOOD_SCENE = preload("res://effects/PlayerBlood.tscn")

onready var default_shape_scale = $Circle.scale

var velocity = Vector2.ZERO


var base_modulate = modulate setget set_base_modulate

var reload_speed = base_reload_speed
var damage = base_damage
var can_shoot = true
var is_dead = false setget set_is_dead

var powerup_reset = []

var topLeft = null
var bottomRight = null

var parent = null


onready var current_weapon = $Weapons/Normal
onready var shoot_dir = $ShootDir
onready var move_joystick = get_parent().get_node("UI/Container/Joysticks/MoveJoystick/JoystickButton")
onready var shoot_joystick = get_parent().get_node("UI/Container/Joysticks/ShootJoystick/JoystickButton")

func _ready() -> void:
	Global.update_OS_status()
	if not Global.is_mobile:
		move_joystick.get_parent().hide()
		shoot_joystick.get_parent().hide()

	Global.player = self
	self.is_dead = false
	parent = get_parent()
	if parent != null:
		topLeft = parent.get_node("Camera2D/Limits/TopLeft")
		bottomRight = parent.get_node("Camera2D/Limits/BottomRight")
	
func _exit_tree() -> void:
	Global.player = null

func _physics_process(delta: float) -> void:
	if is_dead: return
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	

	if Global.is_mobile:
		input_vector = move_joystick.get_value()		
		
		if shoot_joystick.event_is_pressed and Global.node_creation_parent != null and can_shoot:
			shoot_dir.set_cast_to(shoot_joystick.get_value())
			
			if damage >= 3:
				Global.vibrate(2)
			elif damage >= 2:
				Global.vibrate(1)
			else:
				Global.vibrate()
				
			var ray_endpoint = shoot_dir.global_position + shoot_dir.cast_to
			var recoil = current_weapon.shoot(damage, ray_endpoint, modulate)
			velocity += recoil * global_position.direction_to(ray_endpoint).normalized()
			can_shoot = false
			Global.camera.screen_shake(5, 0.01)
			$ReloadSpeed.start()
			current_weapon.look_at(ray_endpoint)
	else:
		if Input.is_action_pressed("shoot") and Global.node_creation_parent != null and can_shoot:
			var direction = get_global_mouse_position() 
			var recoil = current_weapon.shoot(damage, direction, modulate)
			velocity += recoil * global_position.direction_to(direction).normalized()
			can_shoot = false
			Global.camera.screen_shake(5, 0.01)
			$ReloadSpeed.start()

		$Weapons.look_at(get_global_mouse_position())
			
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().notification(MainLoop.NOTIFICATION_APP_PAUSED)
			
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		rotation /= 2

	
	move()
	squash_stretch(delta)
	var new_modulate = Color.from_hsv(base_modulate.h + (damage * 0.2), base_modulate.s + (damage * 0.2), base_modulate.v - (damage * 0.05), base_modulate.a)
	modulate = lerp(modulate, new_modulate, 0.3)
	
func move() -> void:
	velocity = move_and_slide(velocity)
	global_position.x = clamp(global_position.x, topLeft.position.x + 15, bottomRight.position.x - 15)
	global_position.y = clamp(global_position.y, topLeft.position.y + 15, bottomRight.position.y - 15)
	
func squash_stretch(delta) -> void:
	var scale_vel = Vector2(abs(velocity.x), abs(velocity.y))
	var squash = ((scale_vel.y + scale_vel.x) * 0.0002)
	var new_scale = Vector2(squash + default_shape_scale.x, (squash / -1.5) + default_shape_scale.x)
	$Circle.rotation = velocity.angle()
	$Circle.scale = $Circle.scale.move_toward(new_scale, ACCELERATION * delta)

func set_max_speed(new_max_speed: float) -> void:
	MAX_SPEED = new_max_speed
	ACCELERATION += new_max_speed
	
func set_base_damage(new_damage: float) -> void:
	base_damage = new_damage
	damage = max(base_damage, damage)
	
func set_base_reload_speed(new_reload_speed: float) -> void:
	base_reload_speed = new_reload_speed
	reload_speed = max(base_reload_speed, reload_speed)

func set_base_modulate(new_modulate: float) -> void:
	base_modulate = new_modulate
	modulate = base_modulate
	
func _on_Timer_timeout() -> void:
	can_shoot = true
	$ReloadSpeed.wait_time = reload_speed
	
func _on_HitBox_area_entered(area: Area2D) -> void:
	if god_mode: return
	if area.is_in_group("enemy") and not is_dead:
		Input.vibrate_handheld(500)
		Global.play_sound("res://assets/sounds/player-death.wav")
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
		reload_speed = base_reload_speed
		powerup_reset.erase("PowerupReload")
	if powerup_reset.find("PowerupDamage") != null:
		damage = base_damage
		powerup_reset.erase("PowerupDamage")
