extends Camera2D

var screen_shake_started = false
var shake_intensity = 0
var zoom_factor = 0.0015
var damp = 0.3

func _ready() -> void:
	Global.camera = self
	
func _exit_tree() -> void:
	Global.camera = null
	
func _process(delta: float) -> void:
	zoom = lerp(zoom, Vector2(1, 1), damp)
	
	if screen_shake_started:
		global_position += Vector2(rand_range(-shake_intensity, shake_intensity), rand_range(-shake_intensity, shake_intensity)) * delta
	else:
		global_position = lerp(global_position, Vector2(320, 180), damp)
		
func screen_shake(intensity, time):
	zoom = Vector2(1, 1) - Vector2(intensity * zoom_factor, intensity * zoom_factor)
	shake_intensity = intensity
	$ScreenShakeTime.wait_time = time
	$ScreenShakeTime.start()
	screen_shake_started = true

func _on_ScreenShakeTime_timeout() -> void:
	screen_shake_started = false
