extends Camera2D

export(bool) var useLimits = true
var screen_shake_started = false
var shake_intensity = 0
var zoom_factor = 0.0015
var damp = 0.3


onready var base_zoom = zoom
onready var topLeft = $Limits/TopLeft
onready var bottomRight = $Limits/BottomRight

func _ready() -> void:
	Global.camera = self
	if useLimits:
		limit_top = topLeft.position.y
		limit_left = topLeft.position.x
		limit_bottom = bottomRight.position.y
		limit_right = bottomRight.position.x

func _exit_tree() -> void:
	Global.camera = null
	
func _process(delta: float) -> void:
	zoom = lerp(zoom, base_zoom, damp)
	
	if screen_shake_started:
		global_position += Vector2(rand_range(-shake_intensity, shake_intensity), rand_range(-shake_intensity, shake_intensity)) * delta
	else:
		global_position = lerp(global_position, Vector2(320, 180), damp)
		
func screen_shake(intensity, time):
	if intensity > shake_intensity:
		zoom = base_zoom - Vector2(intensity * zoom_factor, intensity * zoom_factor)
		shake_intensity = intensity
		$ScreenShakeTime.wait_time = time
		$ScreenShakeTime.start()
		screen_shake_started = true

func _on_ScreenShakeTime_timeout() -> void:
	screen_shake_started = false
	shake_intensity = 0
