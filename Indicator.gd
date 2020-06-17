extends Node2D

export(NodePath) var target_path
export(float) var offset = 50

onready var shape = $Shape

var target_position = null


func _physics_process(delta: float) -> void:
	var canvas = get_canvas_transform()
	var top_left = -canvas.origin / canvas.get_scale()
	var size = get_viewport_rect().size / canvas.get_scale()
	
	set_indicator_position(Rect2(top_left, size))
	set_indicator_rotation()
	
func set_indicator_position(bounds: Rect2):
	if target_position ==  null:
		shape.global_position.x = clamp(global_position.x, bounds.position.x + offset, bounds.end.x - offset)
		shape.global_position.y = clamp(global_position.y, bounds.position.y + offset, bounds.end.y - offset)
	else:
		var displacement = global_position - target_position
		var length
		
		var tl = (bounds.position - target_position).angle()
		var tr = (Vector2(bounds.end.x, bounds.position.y) - target_position).angle()
		var bl = (Vector2(bounds.position.x, bounds.end.y) - target_position).angle()
		var br = (bounds.end - target_position).angle()
		if (displacement.angle() > tl && displacement.angle() > tr) \
			|| (displacement.angle() < bl && displacement.angle() > br):
			var y_length = clamp(displacement.y, bounds.position.y - target_position.y, \
					bounds.end.y - target_position.y)
			var angle = displacement.angle() - PI / 2.0
			length = y_length / cos(angle) if cos(angle) != 0 else y_length
		else:
			var x_length = clamp(displacement.x, bounds.position.x - target_position.x, \
					bounds.end.x - target_position.x)
			var angle = displacement.angle()
			length = x_length / cos(angle) if cos(angle) != 0 else x_length
	
		shape.global_position = polar2cartesian(length, displacement.angle()) + target_position	
		
	if bounds.has_point(global_position):
		hide()
		$AudioStreamPlayer2D.stream_paused = true
	else:
		show()
		$AudioStreamPlayer2D.stream_paused = false
		
func set_indicator_rotation():
	var angle = (global_position - shape.global_position).angle()
	shape.global_rotation = angle
