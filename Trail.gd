extends Line2D


export(NodePath) var targetPath
export var trailLength = 1
export var maxFrames = 15
export var wobble = false
export var wobbleStrenth = 20
export var target_width_multiplier = 100
export var target_trailLength_multiplier = 50

onready var default_width = width
onready var default_trailLength = trailLength

var target
var point
var speed = 0
var frameCount = 0

func _ready() -> void:
	target = get_node(targetPath)
	default_width = width
	default_trailLength = trailLength
	
func _physics_process(delta: float) -> void:
	global_position = Vector2.ZERO
	rotation = 0
	width = default_width + (target_width_multiplier * target.scale.y)
	trailLength = default_trailLength + (target_trailLength_multiplier * target.scale.x)
	point = target.global_position
	add_point(point)
	
	if wobble: wobble(delta)
	
	while get_point_count() > trailLength:
		remove_point(0)
		
func wobble(delta: float) -> void:
	frameCount %= maxFrames
	for i in range(points.size()):
		if i > 0 and i < trailLength / 4:
			speed = rand_range(-wobbleStrenth, wobbleStrenth)
		elif i > trailLength / 4 + 1 and i < trailLength / 2:
			speed = rand_range(-wobbleStrenth * 2, wobbleStrenth * 2)
		elif i > trailLength / 2 + 1 and i < trailLength * 0.75:
			speed = rand_range(-wobbleStrenth * 3, wobbleStrenth * 3)
		var target_velocity = target.velocity.normalized()		
		var wobble_vec_normal = Vector2(abs(target_velocity.x), abs(target_velocity.y)).normalized()
		var wobble_speed = ((wobble_vec_normal.y + wobble_vec_normal.x)) * speed
		var new_point_position = Vector2(get_point_position(i).x + (wobble_speed * delta), get_point_position(i).y + (wobble_speed * delta))
		set_point_position(i, new_point_position)
	
