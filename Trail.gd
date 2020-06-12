extends Line2D

var target
var point
export(NodePath) var targetPath
export var trailLength = 10
export var speedY = 0
export var maxFrames = 15
export var wobble = false
export var wobbleStrenth = 20
var speedX = 0
var frameCount = 0
onready var default_width = width
onready var default_trailLength = trailLength

func _ready() -> void:
	target = get_node(targetPath)
	default_width = width
	default_trailLength = trailLength
	
func _process(delta: float) -> void:
	global_position = Vector2.ZERO
	rotation = 0
	width = default_width + (100 * target.scale.y)
	trailLength = default_trailLength + (50 * target.scale.x)
	point = target.global_position
	add_point(point)
	frameCount %= maxFrames
	while get_point_count() > trailLength:
		remove_point(0)
	for i in range(points.size()):
		if wobble:
			if i > 0 and i < trailLength / 4:
				speedX = rand_range(-wobbleStrenth, wobbleStrenth)
			elif i > trailLength / 4 + 1 and i < trailLength / 2:
				speedX = rand_range(-wobbleStrenth * 2, wobbleStrenth * 2)
			elif i > trailLength / 2 + 1 and i < trailLength * 0.75:
				speedX = rand_range(-wobbleStrenth * 3, wobbleStrenth * 3)
		set_point_position(i, Vector2(get_point_position(i).x + (speedX * delta), get_point_position(i).y + (-speedY * delta)))
	
